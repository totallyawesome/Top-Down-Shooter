//
//  RIPlanCharacter.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlan.h"
#import "RIGameObject.h"

@interface RIPlanCharacter : RIPlan
{
    CGSize screenSize;
    
    BOOL _isStable;
    BOOL _isBanked;
    BOOL _isReturned;
}

+(float) angleInDegreesBetweenSelfPoint:(CGPoint)selfPoint andOtherPoint:(CGPoint)otherPoint;
-(void)restrictTargetToCage:(RIGameObject*)targetCharacter desiredPosition:(CGPoint *)desiredPosition_p;
-(void)handleRollForDesiredPosition:(CGPoint)desiredDirection gameObject:(RIGameObject*)gameObject;

@end
