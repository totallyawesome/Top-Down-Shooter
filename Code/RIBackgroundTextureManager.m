//
//  RIBackgroundTextureManager.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIBackgroundTextureManager.h"

@implementation RIBackgroundTextureManager

static RIBackgroundTextureManager* instanceOfBackgroundTextureManager;
+(RIBackgroundTextureManager*)sharedBackgroundTextureManager
{
    NSAssert(instanceOfBackgroundTextureManager != nil, @"RIBackgroundTextureManager is not initialized");
    return instanceOfBackgroundTextureManager;
}

+(RIBackgroundTextureManager*)backgroundTextureManager
{
    return [[[self alloc]init]autorelease];
}

-(id)init
{
    if (self = [super init])
    {
        _textureNameToHolderMapping = [[NSMutableDictionary alloc]init];
        instanceOfBackgroundTextureManager = self;
    }
    
    return self;
}

-(void)dealloc
{
    [_textureNameToHolderMapping removeAllObjects];
    [_textureNameToHolderMapping release];
    _textureNameToHolderMapping = nil;
    
    [super dealloc];
}

-(void)requestLoadTexture:(NSString*)textureName target:(id)target selector:(SEL)selector async:(BOOL)loadAsync
{
    //Check if the texture is not loaded. If it is not loaded, then load it. Mark as being currently used.
    //We should hold only so many textures in memory. The least recently used it chucked out.
    @synchronized(_lock)
    {
        NSMutableArray* holders = [_textureNameToHolderMapping objectForKey:textureName];
        if (!holders) 
        {
            holders = [[[NSMutableArray alloc]init]autorelease];
            [holders addObject:target];

            [_textureNameToHolderMapping setObject:holders forKey:textureName];
            if (loadAsync)
            {
                [[CCTextureCache sharedTextureCache]addImageAsync:textureName target:target selector:selector];
            }
            else 
            {
                CCTexture2D* texture = [[CCTextureCache sharedTextureCache]addImage:textureName];
                [target performSelector:selector withObject:texture];
            }
        }
        else 
        {
            [holders addObject:target];
            CCTexture2D* texture = [[CCTextureCache sharedTextureCache]textureForKey:textureName];
            [target performSelector:selector withObject:texture];
        }        
    }    
}

-(void)informTextureNotRequired:(NSString*)textureName source:(id)holder
{
    //Check if no one needs this texture soon. If it is not going to be used soon, then unload it from memory.
    @synchronized(_lock)
    {
        NSMutableArray* holders = [_textureNameToHolderMapping objectForKey:textureName];
        if (holders) 
        {
            [holders removeObjectIdenticalTo:holder];
            if (holders.count == 0) 
            {
                [_textureNameToHolderMapping removeObjectForKey:textureName];
                [[CCTextureCache sharedTextureCache]removeTextureForKey:textureName];
                [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrameByName:textureName];
            }
        }
    }
}

@end
