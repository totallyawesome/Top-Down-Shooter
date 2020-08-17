//
//  RISimpleAudioEngineExtended.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RISimpleAudioEngineExtended.h"

@implementation SimpleAudioEngine(pauseFX)

-(void)pauseAllEffects
{
	[[CDAudioManager sharedManager].soundEngine pauseAllSounds];
}

-(void)resumeAllEffects
{
    [[CDAudioManager sharedManager].soundEngine resumeAllSounds];
}

-(void)stopAllEffects
{
    [[CDAudioManager sharedManager].soundEngine stopAllSounds];
}

-(BOOL)isOtherAudioPlaying
{
    return [[CDAudioManager sharedManager]isOtherAudioPlaying];
}

@end
