//
//  RICommon.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIConstants.h"
#import "RIFileManager.h"

@interface RICommon : NSObject

typedef enum
{
    RIZOrderUniverse = 0,
    RIZOrderSpace = 1,
    
    RIZorderBackgroundForDialogue = 48,
    RIZorderParticlesExplosionsBatchNode = 49,
    RIZOrderGameObjectsSpriteBatchNode = 50,
    RIZOrderDialogue = 51,
    
    RIZorderInputLayerControls = 100,
    RIZOrderLayerStartTransition = 150,
    RIZOrderLayerFailureTransition = 150,
    
    RIZOrderGameTitle = 199,
    
    //Things which aren't directly relevant to the game.
    RIZOrderPauseButton = 200,
    RIZOrderLayerMenuMain = 200,
    RIZOrderLayerMenuChapterSelect = 200,
    RIZOrderLayerMenuOptions = 200,
    RIZOrderLayerMenuPause = 200,
}RIZOrder;

typedef enum
{
    RITagButtonPause = 0,
}RITag;

extern const float CubicLagrangePinnedKnot[4];

+(NSMutableArray*)sortXmlByIndexAttribute:(NSArray*)dataArray;
+(NSMutableArray*)sortXmlArray:(NSArray*)dataArray byAttribute:(NSString*)attribute;

@end
