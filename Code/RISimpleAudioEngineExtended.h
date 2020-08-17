//
//  RISimpleAudioEngineExtended.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "RICocosDenshionExtended.h"
#import "RICDAudioManagerExtended.h"

@interface SimpleAudioEngine(pauseFX)

-(void)pauseAllEffects;
-(void)resumeAllEffects;
-(void)stopAllEffects;
-(BOOL)isOtherAudioPlaying;

@end
