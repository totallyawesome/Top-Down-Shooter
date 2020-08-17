//
//  RIManagerDialogue.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RICommon.h"
#import "RIDialogue.h"

@interface RIManagerDialogue : NSObject
{
    RIDialogue* _currentDialogue;
    float _timeSinceStartedSpeakingDialogue;
    CCLabelBMFont* _lineBeingSpoken;
    CCSprite* _characterSpeakingLine;
    
    float _dialogueWidth;
    CGPoint _position;
    CCLayerColor* _backgroundForDialogue;
}

@property(nonatomic,retain)RIDialogue* currentDialogue;

+(RIManagerDialogue*)sharedManager;

-(void)reset;
-(void)speakDialogue:(RIDialogue*)dialogue;
-(void)manageDialogue:(ccTime)delta;

@end
