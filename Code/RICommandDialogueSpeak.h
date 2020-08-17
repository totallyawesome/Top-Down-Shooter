//
//  RICommandDialogueSpeak.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommand.h"
#import "RIDialogue.h"

@interface RICommandDialogueSpeak : RICommand
{
    RIDialogue* _dialogue;
}

@property(nonatomic,retain)RIDialogue* dialogue;

@end
