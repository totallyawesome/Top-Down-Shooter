//
//  RISpaceRepeatingFiniteNumber.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RISpaceRepeatingFiniteNumber.h"

@implementation RISpaceRepeatingFiniteNumber

-(id)initWithXML:(GDataXMLElement *)spaceXML offset:(float)offset
{
    if (self = [super initWithXML:spaceXML offset:offset])
    {
        _numberOfTimesSpaceHasCompletedScrollingFully = 0;
        _numberOfTimesToScroll = [[[spaceXML attributeForName:RIKEY_NUMBER_OF_TIMES_TO_SCROLL]stringValue]intValue];
    }
    
    return self;
}

-(void)pushBackgroundToBack:(RIBackground *)background backgroundIndex:(int)backgroundIndex
{
    [super pushBackgroundToBack:background backgroundIndex:backgroundIndex];
    if (backgroundIndex == 0)
    {
        _numberOfTimesSpaceHasCompletedScrollingFully++;
        if (_numberOfTimesSpaceHasCompletedScrollingFully > _numberOfTimesToScroll -2)
        {
            [self switchToAlignBackToOriginalPosition];
        }
    }
}

-(void)deactivate
{
    [super deactivate];
    _numberOfTimesSpaceHasCompletedScrollingFully = 0;
}

@end
