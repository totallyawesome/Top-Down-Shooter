//
//  RISpace.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "GDataXMLNode.h"
#import "RIEnergyCosmic.h"

@interface RISpace : CCNode
{
    BOOL _isHD;
    BOOL _isActiveSpace;
    BOOL _isDemo;
    
    CGSize _winSize;
    
    float _endY;
    float _heightOfEachBackgroundImage;
    float _scrollRate;    
    float _startY;
    float _totalHeight;
    
    int _spaceId;
    
    NSMutableArray* _backgrounds;
    
    RIEnergyCosmic* _cosmicEnergy;
    
    int _nextBackgroundToUnloadIndex;
    int _nextBackgroundToLoadIndex;
}

@property (nonatomic,assign)float endY;
@property (nonatomic,assign)float scrollRate;
@property (nonatomic,assign)float startY;
@property (nonatomic,assign)float totalHeight;
@property (nonatomic,assign)BOOL isActiveSpace;
@property (atomic, readonly)int spaceId;
@property (nonatomic,readonly)BOOL isDemo;

-(void)deactivate;
-(id)initWithXML:(GDataXMLElement*)spaceXML offset:(float)offset;
+(RISpace*)spaceWithXML:(GDataXMLElement*)spaceXML offSet:(float)offSet;
-(void)updateBackgroundsAsync:(BOOL)async;
-(void)act:(ccTime)delta;

@end
