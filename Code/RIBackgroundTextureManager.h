//
//  RIBackgroundTextureManager.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface RIBackgroundTextureManager : NSObject
{
    NSMutableDictionary* _textureNameToHolderMapping;
    NSObject* _lock;
}

+(RIBackgroundTextureManager*)sharedBackgroundTextureManager;
+(RIBackgroundTextureManager*)backgroundTextureManager;

-(void)requestLoadTexture:(NSString*)textureName target:(id)target selector:(SEL)selector async:(BOOL)loadAsync;
-(void)informTextureNotRequired:(NSString*)textureName source:(id)holder;


@end
