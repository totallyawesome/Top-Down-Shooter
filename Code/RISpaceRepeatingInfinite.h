//
//  RISpaceFiniteRepeating.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIBackground.h"
#import "RICommon.h"
#import "RISpace.h"

@interface RISpaceRepeatingInfinite : RISpace
{
    BOOL _isRepeating;
    BOOL _isAligningBackToOriginalPosition;
    
    float _spaceScrollRate;
    NSMutableArray* _originalPositionsOfBackgrounds;    
}

- (void)pushBackgroundToBack:(RIBackground *)background backgroundIndex:(int)backgroundIndex;
- (void)switchToAlignBackToOriginalPosition;

@end
