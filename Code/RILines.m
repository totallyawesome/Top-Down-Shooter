//
//  RILines.m
//  ProjectX
//
//  Created by Rahul Iyer on 22/02/12.
//  Copyright (c) 2012 rahuliyer@me.com. All rights reserved.
//
#import "cocos2d.h"
#import "RILines.h"

@implementation RILines

+(NSMutableArray*)quadLagrangePinnedKnot
{
    NSMutableArray* array = [[[NSMutableArray alloc]init]autorelease];
    [array addObject:[NSNumber numberWithFloat:0]];
    [array addObject:[NSNumber numberWithFloat:0.5]];
    [array addObject:[NSNumber numberWithFloat:1]];
    
    return array;
}

+(NSMutableArray*)cubicLagrangePinnedKnot
{
    NSMutableArray* array = [[[NSMutableArray alloc]init]autorelease];
    [array addObject:[NSNumber numberWithFloat:0]];
    [array addObject:[NSNumber numberWithFloat:0.33]];
    [array addObject:[NSNumber numberWithFloat:0.66]];
    [array addObject:[NSNumber numberWithFloat:1]];
    
    return array;
}

+(NSMutableArray*) cubicParamsMakeWithStart:(CGPoint) start controlPoint1:(CGPoint) cp1 controlPoint2:(CGPoint) cp2 endPoint:(CGPoint) end
{
    NSMutableArray* params = [[[NSMutableArray alloc]init]autorelease];
    
    [params addObject:[NSValue valueWithCGPoint:start]];
    [params addObject:[NSValue valueWithCGPoint:cp1]];
    [params addObject:[NSValue valueWithCGPoint:cp2]];
    [params addObject:[NSValue valueWithCGPoint:end]];
    
    return params;
}

+(NSMutableArray*) quadParamsMakeWithStart:(CGPoint) start controlPoint1:(CGPoint) cp1 endPoint:(CGPoint) end
{
    NSMutableArray* params = [[[NSMutableArray alloc]init]autorelease];
    
    [params addObject:[NSValue valueWithCGPoint:start]];
    [params addObject:[NSValue valueWithCGPoint:cp1]];
    [params addObject:[NSValue valueWithCGPoint:end]];
    
    return params;
}

CGPoint ccpAitkenLagrangeStep(ccTime t, const CGPoint *CP, int CPCount, const float *ti, float tiCount)
{
	float *bF = malloc(tiCount*sizeof(float)); 
	
    for (int j = 0; j < tiCount; ++j)
    {
		float P = 1;
		for (int i = 0; i < tiCount; ++i)
        {
			if (i != j) 
				P = P*(t-ti[i])/(ti[j] - ti[i]);
		}
        
		bF[j] = P;
	}
	
	CGPoint pt = CGPointZero;
	for(int j = 0; j < CPCount; ++j)
    {
		pt = ccpAdd(pt,ccpMult(CP[j],bF[j]));
	}
    
	free(bF);
	return pt;
}

+(CGPoint) deCasteljauBezierWithTime:(ccTime)dt andParams:(NSMutableArray*)CP
{
    NSMutableArray* Pi = [CP copy];
    
    for (int j=CP.count-1; j>0; j--)
    {
        for (int i=0; i<j; i++)
        {
            [Pi replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:(ccpLerp([[Pi objectAtIndex:i]CGPointValue], [[Pi objectAtIndex:(i+1)]CGPointValue], dt))]];
        }
    }
    
    CGPoint pt = [[Pi objectAtIndex:0]CGPointValue];
    [Pi release];
    Pi = nil;
    
    return pt;
}

@end
