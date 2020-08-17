//
//  RIUniverse.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "CCNode.h"
#import "RICommon.h"
#import "RISpace.h"
#import "RITransition.h"
#import "RIManagerDialogue.h"

@interface RIUniverse : CCNode
{
    NSMutableArray* _spaces;
    RISpace* _activeSpace;
    int _activeSpaceIndex;
    float _currentSpaceEndYLimit;
    CGSize _winSize;
    float _viewLimit;
    BOOL _isPlayerAlive;
    
    BOOL _isStarted;
    BOOL _isPreTransitioning;
    BOOL _isTransitioning;
    CCLayer* _fadeLayer;
    
    RIManagerDialogue* _dialogueManager;
    
    RITransition* _failureTransition;
    RITransition* _startTransition;
}

@property(nonatomic,retain)RISpace* activeSpace;

+(RIUniverse*)universeWithXML:(GDataXMLElement*)universeXML;
-(void)loadFromSpace:(int)spaceIndex;
-(void)resumePlaying;
-(void)pausePlaying;
-(void)stopPlaying:(BOOL)isDemo;

@end
