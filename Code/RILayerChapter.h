//
//  RILayerChapter.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "RICommon.h"
#import "GDataXMLNode.h"

@interface RILayerChapter : CCLayer
{
    NSString* _name;
    NSString* _previewSpriteName;
    
    int _number;
    int _spaceId;
    int _demoSpaceIndex;
    BOOL _isUnlocked;
    
    CCMenu* _menu;
    id _responder;
}

@property (nonatomic,retain)CCMenu* menu;
@property (nonatomic,readonly)int spaceId;
@property (nonatomic,readonly)int demoSpaceIndex;

+(RILayerChapter*)layerWithChapter:(GDataXMLElement*)chapterXML responder:(id)responder highestUnlockedChapter:(int)highestUnlockedChapter;
-(id)initWithChapter:(GDataXMLElement*)chapterXML responder:(id)responder highestUnlockedChapter:(int)highestUnlockedChapter;

-(void)loadPreviewImage;
-(void)unloadPreviewImage;
-(void)unlock;

@end
