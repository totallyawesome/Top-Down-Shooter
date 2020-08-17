//
//  RILayerGamePlay.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "RIManagerDialogue.h"
#import "RIUniverse.h"

@interface RILayerGamePlay : CCLayer
{
    RIUniverse* _universe;
    CCSpriteBatchNode* _spriteBatchNode;
    CCParticleBatchNode* _explosionParticleBatchNode;
    CCParticleBatchNode* _smokeParticleBatchNode;
    
    RIManagerDialogue* _dialogueManager;
    
    BOOL _isPaused;
    BOOL _isDemoing;
}

@property(nonatomic,retain)CCSpriteBatchNode* spriteBatchNode;
@property(nonatomic,retain)CCParticleBatchNode* explosionsParticleBatchNode;
@property(nonatomic,retain)CCParticleBatchNode* smokeParticleBatchNode;
@property(nonatomic,assign)BOOL isDemoing;
@property(nonatomic,retain)RIUniverse* universe;

+(RILayerGamePlay*) sharedLayerGamePlay;
+(RILayerGamePlay*)layerWithGameData:(GDataXMLDocument*)gameData;
-(void)startPlayingFrom:(int)index isDemo:(BOOL)isDemo;
-(void)stopPlaying;
-(void)resumePlaying:(BOOL)isDemo;
-(void)pausePlay;
-(void)becomeActive;
-(void)startDemo;

@end
