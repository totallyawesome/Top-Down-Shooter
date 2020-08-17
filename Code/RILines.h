//
//  RILines.h
//  ProjectX
//
//  Created by Rahul Iyer on 22/02/12.
//  Copyright (c) 2012 rahuliyer@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface RILines : NSObject
{
}

+(NSMutableArray*)cubicLagrangePinnedKnot;
+(NSMutableArray*)quadLagrangePinnedKnot;

+(NSMutableArray*) cubicParamsMakeWithStart:(CGPoint) start controlPoint1:(CGPoint) cp1 controlPoint2:(CGPoint) cp2 endPoint:(CGPoint) end;

+(NSMutableArray*) quadParamsMakeWithStart:(CGPoint) start controlPoint1:(CGPoint) cp1 endPoint:(CGPoint) end;

CGPoint ccpAitkenLagrangeStep(ccTime t, const CGPoint *CP, int CPCount, const float *ti, float tiCount);


@end
