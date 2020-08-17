//
//  RIPlanBoss.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlanBoss.h"
#import "RIGameObject.h"
#import "RIPlanCrash.h"
#import "RILines.h"

@implementation RIPlanBoss

-(id)initWithTarget:(id)target dismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    if (self = [super initWithTarget:target dismisser:dismisser data:data])
    {
        _duration = 3;
        _pointParams[0] = [[data objectForKey:RIKEY_START]CGPointValue];
        _pointParams[1] = [[data objectForKey:RIKEY_CP1]CGPointValue];
        _pointParams[2] = [[data objectForKey:RIKEY_CP2]CGPointValue];
        _pointParams[3] = [[data objectForKey:RIKEY_END_POINT]CGPointValue];
        
        screenSize = [[CCDirector sharedDirector]winSize];
        _isTargetCaged = NO;
        _isCollidable = YES;
        _strength = 1;
        _health = 10;
        _stage1Complete = NO;
        _stage2Complete = NO;
        _stage3Complete = NO;
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(BOOL)execute:(ccTime)delta
{
    BOOL isComplete = NO;
    BOOL isGoingToCrash = [self isDamageCatastrophic];
    
    if (isGoingToCrash)
    {
        RIGameObject* gameObject = (RIGameObject*)_target;
        
        RIPlanCrash* crashPlan = [[RIPlanCrash alloc]initWithTarget:gameObject dismisser:nil data:nil];
        gameObject.plan = crashPlan;
        [crashPlan release];
        [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_STOP_REPEATING1 object:self];
        
        return NO;
    }
    
    if (!_stage1Complete)
    {
        _elapsed +=delta;
        
        ccTime t = MIN(1,_elapsed/MAX(_duration, FLT_EPSILON));
        
        _stage1Complete = [self travel:t];
    }
    else if(!_stage2Complete)
    {
        //DO Nothing.
    }
    else if(!_stage3Complete)
    {
        
        if (_stage3Complete)
        {
            _stage2Complete = NO;
            _stage3Complete = NO;
        }
    }
    
    return isComplete;
}

-(BOOL)travel:(ccTime)t
{
    BOOL isDone = NO;
    
    RIGameObject* gameObject = (RIGameObject*)_target;
    CGPoint step = ccpAitkenLagrangeStep(t, _pointParams, 4, CubicLagrangePinnedKnot, 4);
    
    [self receiveMoveCommand:gameObject destination:step];
    
    if (gameObject.position.y == _pointParams[3].y)
    {
        isDone = YES;
    }
    
    return isDone;
}

-(void)receiveMoveCommand:(RIGameObject*)gameObject destination:(CGPoint)destination
{
    CGPoint desiredPosition;
    CGPoint offsetPosition;
    
    desiredPosition = destination;
    offsetPosition = CGPointMake(destination.x - gameObject.position.x, destination.y-gameObject.position.y);
    
    gameObject.flipY = NO;    
    if (_isTargetCaged)
    {
        [self restrictTargetToCage:gameObject desiredPosition: &desiredPosition];
    }
    
    [self handleRollForDesiredPosition:offsetPosition gameObject:gameObject];
    
    gameObject.position = desiredPosition;
}

@end
