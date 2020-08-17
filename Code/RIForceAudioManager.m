//
//  RIForceAudioManager.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//
#import "RIAudioManager.h"
#import "RICommandPlayMusic.h"
#import "RICommandStopMusic.h"
#import "RIForceAudioManager.h"

@implementation RIForceAudioManager

-(void)executeCommand:(id)command
{
    if ([command isKindOfClass:[RICommandPlayMusic class]])
    {
        RICommandPlayMusic* playMusicCommand = (RICommandPlayMusic*)command;
        [self playMusic:playMusicCommand];
    }
    else if([command isKindOfClass:[RICommandStopMusic class]])
    {
        RICommandStopMusic* stopMusicCommand = (RICommandStopMusic*)command;
        [self stopMusic:stopMusicCommand];
    }
}

-(void)playMusic:(RICommandPlayMusic*)command
{
    [[RIAudioManager sharedAudioManager]playMusicAsync:command.trackName];
}

-(void)stopMusic:(RICommandStopMusic*)command
{
    [[RIAudioManager sharedAudioManager]stopMusic];
}


@end
