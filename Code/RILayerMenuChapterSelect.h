//
//  RILayerChapterSelect.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GDataXMLNode.h"

@interface RILayerMenuChapterSelect : CCLayer
{
    NSMutableArray* _layers;
    NSMutableDictionary* _spaceChapterMapping;
    NSObject* _layerModifierLock;
    
    int _highestUnlockedChapter;
}

+(RILayerMenuChapterSelect*)sharedLayer;
+(RILayerMenuChapterSelect*)layerWithGameData:(GDataXMLDocument*)document;
-(id)initWithGameData:(GDataXMLDocument*)document;

-(void)unlockLevelForSpaceId:(int)spaceId;
-(int)demoSpaceIdForHighestUnlockedChapter;

@end
