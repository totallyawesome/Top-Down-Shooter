//
//  RISpace.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIBackground.h"
#import "RICommon.h"
#import "RISpace.h"

@implementation RISpace
@synthesize totalHeight = _totalHeight;
@synthesize startY = _startY;
@synthesize endY = _endY;
@synthesize scrollRate = _scrollRate;
@synthesize isActiveSpace = _isActiveSpace;
@synthesize spaceId = _spaceId;
@synthesize isDemo = _isDemo;

+(RISpace*)spaceWithXML:(GDataXMLElement*)spaceXML offSet:(float)offSet
{
    return [[[self alloc]initWithXML:spaceXML offset:offSet]autorelease];
}

-(id)initWithXML:(GDataXMLElement*)spaceXML offset:(float)offset
{
    if (self = [super init])
    {
        _backgrounds = [[NSMutableArray alloc]init];
        _spaceId = [[[spaceXML attributeForName:RIKEY_INDEX]stringValue]intValue];
        _isDemo = [[[spaceXML attributeForName:RIKEY_IS_DEMO]stringValue]boolValue];
        _winSize = [[CCDirector sharedDirector]winSize];
        _nextBackgroundToUnloadIndex = 0;
        _nextBackgroundToLoadIndex = 0;
        _cosmicEnergy = [RIEnergyCosmic energyWithMysteriousForces:[[spaceXML elementsForName:RIKEY_MYSTERIOUS_FORCES]objectAtIndex:0]];
        [self addChild:_cosmicEnergy];
        
        [self loadBackgrounds:spaceXML offset:offset];
    }
    
    return self;
}

-(void)dealloc
{
    [_backgrounds removeAllObjects];
    [_backgrounds release];
    _backgrounds = nil;
    
    [super dealloc];
}

- (void)loadBackgrounds:(GDataXMLElement *)spaceXML offset:(float)offset
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    
    GDataXMLElement* backgroundConfigElement = [[spaceXML elementsForName:RIKEY_BACKGROUND_CONFIG]objectAtIndex:0];
    
    NSArray* backgroundImageElements = [[[backgroundConfigElement elementsForName:RIKEY_BACKGROUND_IMAGES]objectAtIndex:0]elementsForName:RIKEY_IMAGE];
    
    NSMutableArray* imageElementsInSortOrder = [RICommon sortXmlByIndexAttribute:backgroundImageElements];
    
    NSMutableArray* imageNames = [[[NSMutableArray alloc]init]autorelease];
    
    for(GDataXMLElement* imageElement in imageElementsInSortOrder)
    {
        NSString* imageName = [[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:RIKEY_TEXTURES]stringByAppendingPathComponent:[[imageElement attributeForName:RIATTRIBUTE_NAME]stringValue]];
        [imageNames addObject:imageName];
    }
    
    CCSprite* temp = [CCSprite spriteWithFile:[imageNames objectAtIndex:0]];
    _heightOfEachBackgroundImage = temp.contentSize.height;
    
    
    if (CC_CONTENT_SCALE_FACTOR() == 2)
    {
        _isHD = YES;
        _heightOfEachBackgroundImage /= 2;
    }
    
    int count = imageNames.count;
    _totalHeight = _heightOfEachBackgroundImage * count;

    
    _startY = offset;
    _endY = offset + _totalHeight;
    float yOffset = offset;
    
    for (int i=0; i<count; i++)
    {
        NSAutoreleasePool* forPool = [[NSAutoreleasePool alloc]init];
        
        NSString* currentImageName = [imageNames objectAtIndex:i];
        RIBackground* background = [RIBackground backgroundWithSpriteName:currentImageName];
        background.position = CGPointMake(0,yOffset);
        yOffset+=_heightOfEachBackgroundImage;
        [_backgrounds addObject:background];
        [self addChild:background];
        
        [forPool drain];
    }
    
    int scrollDuration = [[[backgroundConfigElement attributeForName:RIKEY_SCROLL_DURATION]stringValue]intValue];
    
    //TODO Currently the scrollrate is the time to scroll the entire space excluding the last window height. Should this be included? Decide?
    //Right now it makes sense to exclude the last window height, so the last window height acts like a kind of transition, and so we don't schedule any events after the "time" ie - when it enters the last window height.
    _scrollRate = ((_totalHeight - _winSize.height) / scrollDuration)/60.0f;
    
    [pool drain];
}

-(void)updateBackgroundsAsync:(BOOL)async
{
    CGPoint realPosition = [self.parent convertToWorldSpace:self.position];
    int realY = 0-realPosition.y - _startY;
    int startBackground = (int)(realY / _heightOfEachBackgroundImage);
    
    if (startBackground<0) { return;}
    
    int finishBackground = (int)((realY + _winSize.height)/_heightOfEachBackgroundImage);
    finishBackground = MIN(finishBackground+1, _backgrounds.count - 1);
    
    for (;_nextBackgroundToUnloadIndex<startBackground; _nextBackgroundToUnloadIndex++)
    {
        RIBackground* currentBackground = [_backgrounds objectAtIndex:_nextBackgroundToUnloadIndex];
        [currentBackground unloadBackground];
    }
    if (_nextBackgroundToUnloadIndex > 0)
    {
        _nextBackgroundToUnloadIndex--;
    }
    
    for (; _nextBackgroundToLoadIndex <=finishBackground; _nextBackgroundToLoadIndex++)
    {
        RIBackground* currentBackground = [_backgrounds objectAtIndex:_nextBackgroundToLoadIndex];
        [currentBackground loadBackgroundAsync:async];
    }
}

//This method should be called when an active space is no longer active.
//Include any other things to do when a space is no longer active.
-(void)deactivate
{
    _isActiveSpace = NO;
    [_cosmicEnergy reset];
    for (int i = 0; i<_backgrounds.count; i++)
    {
        RIBackground* current = [_backgrounds objectAtIndex:i];
        [current unloadBackground];
    }
    _nextBackgroundToUnloadIndex = 0;
    _nextBackgroundToLoadIndex = 0;
}

-(void)act:(ccTime)delta
{
    [_cosmicEnergy doStuff:delta];
}

@end
