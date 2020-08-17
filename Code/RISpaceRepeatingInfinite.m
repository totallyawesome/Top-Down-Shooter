//
//  RISpaceFiniteRepeating.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RISpaceRepeatingInfinite.h"

@implementation RISpaceRepeatingInfinite

-(id)initWithXML:(GDataXMLElement *)spaceXML offset:(float)offset
{
    if (self = [super initWithXML:spaceXML offset:offset])
    {
        _spaceScrollRate = _scrollRate;
        _scrollRate = 0;
        _isRepeating = YES;
        NSString* breakRepeatNotificationString = [[spaceXML attributeForName:RIKEY_BREAK_FLAG]stringValue];
        
        if (breakRepeatNotificationString)
        {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveBreakNotification:) name:breakRepeatNotificationString object:nil];
        }
        
        _originalPositionsOfBackgrounds = [[NSMutableArray alloc]init];
        
        for (int currentIndex = 0; currentIndex<_backgrounds.count; currentIndex++)
        {
            RIBackground* background = [_backgrounds objectAtIndex:currentIndex];
            CGPoint position = background.position;
            
            [_originalPositionsOfBackgrounds addObject:[NSValue valueWithCGPoint:position]];
        }
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [_originalPositionsOfBackgrounds removeAllObjects];
    [_originalPositionsOfBackgrounds release];
    _originalPositionsOfBackgrounds = nil;
    
    [super dealloc];
}

- (void)repeatSpaceAsync:(BOOL)async numberOfBackgrounds:(int)numberOfBackgrounds
{
    for(int currentBackgroundIndex = 0; currentBackgroundIndex<numberOfBackgrounds; currentBackgroundIndex++)
    {
        RIBackground* currentBackground = [_backgrounds objectAtIndex:currentBackgroundIndex];
        [self handleVisibilityOfBackground:currentBackground async:async index:currentBackgroundIndex];
        
        
        //Move background down by number of pixes
        if (_isActiveSpace)
        {
            if(async)
            {
                currentBackground.position = CGPointMake(currentBackground.position.x, currentBackground.position.y - _spaceScrollRate);
            }
        }
        
    }
}

- (void)alignBackToOriginalPositionAsync:(BOOL)async numberOfBackgrounds:(int)numberOfBackgrounds
{
    RIBackground* firstBackground = [_backgrounds objectAtIndex:0];
    
    float distanceToOriginalPosition = firstBackground.position.y - [[_originalPositionsOfBackgrounds objectAtIndex:0]CGPointValue].y;
    
    BOOL isCloseEnough = NO;
    
    if (distanceToOriginalPosition < 0)
    {
        isCloseEnough = NO;
    }
    else if(distanceToOriginalPosition <  _spaceScrollRate)
    {
        isCloseEnough = YES;
        _isAligningBackToOriginalPosition = NO;
        _scrollRate = _spaceScrollRate;
    }
    
    for(int currentBackgroundIndex = 0; currentBackgroundIndex<numberOfBackgrounds; currentBackgroundIndex++)
    {
        RIBackground* currentBackground = [_backgrounds objectAtIndex:currentBackgroundIndex];
        [self handleVisibilityOfBackground:currentBackground async:async index:currentBackgroundIndex];
        
        if(isCloseEnough)
        {
            //If distance to original position is less than scroll rate
            //Then move background down to original position
            currentBackground.position = [[_originalPositionsOfBackgrounds objectAtIndex:currentBackgroundIndex]CGPointValue];
        }
        else
        {
            //Else Move background down by number of pixes
            currentBackground.position = CGPointMake(currentBackground.position.x, currentBackground.position.y - _spaceScrollRate);
        }
        
    }
}

-(void)updateBackgroundsAsync:(BOOL)async
{
    int numberOfBackgrounds = _backgrounds.count;
    
    if (_isRepeating)
    {
        [self repeatSpaceAsync:async numberOfBackgrounds:numberOfBackgrounds];
    }
    else if(_isAligningBackToOriginalPosition)
    {
        [self alignBackToOriginalPositionAsync:async numberOfBackgrounds:numberOfBackgrounds];
    }
    else
    {
        [super updateBackgroundsAsync:async];
    }
}

- (void)pushBackgroundToBack:(RIBackground *)background backgroundIndex:(int)backgroundIndex
{
    [background unloadBackground];
    int highestIndex = (_backgrounds.count + backgroundIndex - 1)%(_backgrounds.count);
    
    RIBackground* highestBackground = [_backgrounds objectAtIndex:highestIndex];
    background.position = CGPointMake(highestBackground.position.x,highestBackground.position.y+_heightOfEachBackgroundImage);
}

-(void)handleVisibilityOfBackground:(RIBackground*)background async:(BOOL)async index:(int)backgroundIndex
{
    //Check its location
    //If its start in visible range
    //Load it async
    //If its start is above visible range
    //do nothing
    //If its end is below visible range
    //unload it.
    //Move its location above the last one. This position must be constant, as it is the original start position of the last index.
    
    float yPosition = [background.parent convertToWorldSpace:background.position].y;
    float endY = 2 * [[CCDirector sharedDirector]winSize].height;
    
    if (yPosition >= 0 && yPosition <=endY)
    {
        [background loadBackgroundAsync:async];
    }
    else if (yPosition + _heightOfEachBackgroundImage <= 0)
    {
        [self pushBackgroundToBack:background backgroundIndex:backgroundIndex];
    }
}

-(void)deactivate
{
    [super deactivate];
    
    _scrollRate  = 0;
    _isRepeating = YES;
    _isAligningBackToOriginalPosition = NO;
    
    //Make sure each background is in the original place
    int numberOfBackgrounds = _backgrounds.count;
    for(int currentBackgroundIndex = 0; currentBackgroundIndex<numberOfBackgrounds; currentBackgroundIndex++)
    {
        RIBackground* background = [_backgrounds objectAtIndex:currentBackgroundIndex];
        CGPoint originalLocation = [[_originalPositionsOfBackgrounds objectAtIndex:currentBackgroundIndex]CGPointValue];
        
        background.position = originalLocation;
    }
}

- (void)switchToAlignBackToOriginalPosition
{
    if(_isRepeating)
    {
        if(_isActiveSpace)
        {
            _isRepeating = NO;
            _isAligningBackToOriginalPosition = YES;
        }
    }
}

-(void)receiveBreakNotification:(NSNotification*)notification
{
    [self switchToAlignBackToOriginalPosition];
}

@end

/*
 
 1 0 -5 -10   ----> 50 moved down by 5, 45
 2 10 5 0 -5
 3 20 15 10 5
 4 30 25 20 15
 5 40 35 30 25
 6 50 45 40 35
 
 */
