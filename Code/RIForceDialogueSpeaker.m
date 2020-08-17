//
//  RIForceDialogueSpeaker.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommandDialogueSpeak.h"
#import "RIForceDialogueSpeaker.h"
#import "RIManagerDialogue.h"

@implementation RIForceDialogueSpeaker

-(void)executeCommand:(id)command
{
    if ([command isKindOfClass:[RICommandDialogueSpeak class]])
    {
        [self speakDialogue:command];
    }
    else
    {
        CCLOG(@"Unrecognized command received by RIForceDialogueSpeaker");
    }
}

-(void)speakDialogue:(RICommandDialogueSpeak*)command
{
    [[RIManagerDialogue sharedManager]speakDialogue:command.dialogue];
}

@end
