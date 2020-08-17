//
//  RIBackground.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIBackground.h"
#import "RIBackgroundTextureManager.h"

@implementation RIBackground

+(RIBackground*) backgroundWithSpriteName:(NSString*)imageName
{
    return [[[self alloc]initWithSpriteName:imageName]autorelease];
}

-(id)initWithSpriteName:(NSString*)imageName
{
    if (self = [super init])
    {
        _imageName = [imageName copy];
        _lock = [[NSLock alloc]init];
        _loadedSprite = NO;
        _loadBackgroundCalled = NO;
    }

    return self;
}

-(void)dealloc
{
    [_imageName release];
    _imageName = nil;
    
    [_lock release];
    _lock = nil;
    
    [super dealloc];
}

-(void)loadBackgroundAsync:(BOOL)loadAsync
{
    @synchronized(_lock)
    {
        if (!_loadBackgroundCalled)
        {
            RIBackgroundTextureManager* sharedManager = [RIBackgroundTextureManager sharedBackgroundTextureManager];
            [sharedManager requestLoadTexture:_imageName target:self selector:@selector(loadSprite:) async:loadAsync];
            
            _loadBackgroundCalled = YES;
        }
    }
}

-(void)loadSprite:(CCTexture2D*)texture
{
    @synchronized(_lock)
    {
        [texture setAliasTexParameters];
        _backgroundImage = [CCSprite spriteWithTexture:texture];
        _backgroundImage.anchorPoint = CGPointMake(0,0);
        
        //TODO this is a hack to make black lines disappear.
        _backgroundImage.scale = 1.0005;
        
        //TODO This is a hack. Either test it on a real device, to make sure there is no stutter / jitter, or Make the images 568.
        if ([[CCDirector sharedDirector]winSize].width == 568)
        {
            _backgroundImage.scaleX = 568/_backgroundImage.contentSize.width;
        }
        
        [self addChild:_backgroundImage];
        _loadedSprite = YES;
    }
}

-(void)unloadBackground
{
    @synchronized(_lock)
    {
        if (_loadedSprite)
        {
            RIBackgroundTextureManager* sharedManager = [RIBackgroundTextureManager sharedBackgroundTextureManager];
            [sharedManager informTextureNotRequired:_imageName source:self];
            
            [self removeChild:_backgroundImage cleanup:YES];
            _backgroundImage = nil;
            
            _loadedSprite = NO;
            _loadBackgroundCalled = NO;
        }
    }
}

@end
