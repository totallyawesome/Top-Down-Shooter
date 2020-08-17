//
//  RIPlanProjectile.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "RICoordinateGeometry.h"
#import "RIGameObject.h"
#import "RILines.h"
#import "RIPlanCrash.h"
#import "RIPlanProjectile.h"


@implementation RIPlanProjectile

-(id)initWithTarget:(id)target dismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    if (self = [super initWithTarget:target dismisser:dismisser data:data])
    {
        CGPoint start = [[data objectForKey:RIKEY_START_LOCATION]CGPointValue];
        float rotation =[[data objectForKey:RIKEY_ROTATION]floatValue];
        CGPoint intersectionWithScreenPoint = [[RICoordinateGeometry sharedCoordinateGeometry]pointOnScreenEdgeThatProjectileFirstIntersectsWith:start rotation:rotation];
        
        _pointParams[0] = start;
        _pointParams[1] = CGPointMake((intersectionWithScreenPoint.x+2*start.x)/3, (intersectionWithScreenPoint.y + 2*start.y)/3);
        _pointParams[2] = CGPointMake((2*intersectionWithScreenPoint.x+start.x)/3, (2*intersectionWithScreenPoint.y + start.y)/3);
        _pointParams[3] = intersectionWithScreenPoint;
        
        //TODO: Before shipping, verify that collisions work properly (no "passthrough" or missed collisions such as bullets passing through other objects without detection. You can adjust the factor 1.3 to make the bullet move larger or smaller distances in every frame. Althernatively you can adjust the bullet sprite to be larger or smaller so that there is a larger bounding box for collisions.
        _duration = (ccpDistance(_pointParams[3], start))/(1.3*[[CCDirector sharedDirector]winSize].height);

        _elapsed = 0;
        _isCollidable = YES;
        _strength = 1;
    }
    
    return self;
}

-(BOOL)execute:(ccTime)delta
{
    BOOL isGoingToCrash = [self isDamageCatastrophic];
    
    if (isGoingToCrash)
    {
        RIGameObject* gameObject = (RIGameObject*)_target;
        
        RIPlanCrash* crashPlan = [[RIPlanCrash alloc]initWithTarget:gameObject dismisser:nil data:nil];
        gameObject.plan = crashPlan;
        [crashPlan release];
        return NO;
    }
    
    BOOL isComplete = NO;
    
    _elapsed +=delta;
    
    ccTime t = MIN(1,_elapsed/MAX(_duration, FLT_EPSILON));
    
    isComplete = [self travel:t];
    
    return isComplete;
}

-(BOOL)travel:(ccTime)t
{
    BOOL isDone = NO;
    
    RIGameObject* gameObject = (RIGameObject*)_target;
    CGPoint step = ccpAitkenLagrangeStep(t, _pointParams, 4, CubicLagrangePinnedKnot, 4);
    
    gameObject.position = step;
        
    if (gameObject.position.x == _pointParams[3].x && gameObject.position.y == _pointParams[3].y )
    {
        isDone = YES;
    }
    
    return isDone;
}

@end
