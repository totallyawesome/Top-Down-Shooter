//
//  RISpaceRepeatingFiniteNumber.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RISpaceRepeatingInfinite.h"

@interface RISpaceRepeatingFiniteNumber : RISpaceRepeatingInfinite
{
    int _numberOfTimesToScroll;
    int _numberOfTimesSpaceHasCompletedScrollingFully;
}

@end
