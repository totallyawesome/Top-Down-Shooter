//
//  RIPlanEnemy.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIAudioManager.h"
#import "RIGameObject.h"
#import "RILines.h"
#import "RIManagerObject.h"
#import "RIPlanCrash.h"
#import "RIPlanEnemy.h"
#import "RIRoleEnemySidekick.h"
#import "RIRoleFriendSidekick.h"
#import "RIStrategyProjectile.h"

@implementation RIPlanEnemy

-(id)initWithTarget:(id)target dismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    if (self = [super initWithTarget:target dismisser:dismisser data:data])
    {
        _duration = [[data objectForKey:RIKEY_DURATION]floatValue];
        _pointParams[0] = [[data objectForKey:RIKEY_START]CGPointValue];
        _pointParams[1] = [[data objectForKey:RIKEY_CP1]CGPointValue];
        _pointParams[2] = [[data objectForKey:RIKEY_CP2]CGPointValue];
        _pointParams[3] = [[data objectForKey:RIKEY_END_POINT]CGPointValue];
        
        screenSize = [[CCDirector sharedDirector]winSize];
        _isTargetCaged = NO;
        _isCollidable = YES;
        _strength = 1;
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(BOOL)execute:(ccTime)delta
{
    BOOL isGoingToCrash = [self isDamageCatastrophic];
    RIGameObject* gameObject = (RIGameObject*)_target;

    if (isGoingToCrash)
    {        
        RIPlanCrash* crashPlan = [[RIPlanCrash alloc]initWithTarget:gameObject dismisser:nil data:nil];
        gameObject.plan = crashPlan;
        [crashPlan release];
        return NO;
    }
    
    BOOL dontShoot = arc4random()%120;
    if (!dontShoot)
    {
        if ([RIManagerObject sharedManager].hero)
        {
            NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
            [data setObject:[NSValue valueWithCGPoint:gameObject.position] forKey:RIKEY_START_LOCATION];
            int rotation = (int)(gameObject.rotation + 180)%360;
            [data setObject:[NSNumber numberWithFloat:rotation] forKey:RIKEY_ROTATION];
            
            
            Class projectileFaction;
            if ([gameObject.faction isSubclassOfClass:[RIRoleFriend class]])
            {
                projectileFaction = [RIRoleFriendSidekick class];
            }
            else if([gameObject.faction isSubclassOfClass:[RIRoleEnemy class]])
            {
                projectileFaction = [RIRoleEnemySidekick class];
            }
            
            RIWave* foo = [[RIWave alloc]initWithNumberOfObjects:1 faction:projectileFaction isDismissable:NO strategy:[RIStrategyProjectile class] objectName:nil spriteFrameName:RISPRITE_BULLET_FIRE dismissNotification:nil waveData:data];
            
            RIManagerObject* moo = [RIManagerObject sharedManager];
            [moo addWaveToQueue:foo];
            
            [[RIAudioManager sharedAudioManager]playSoundEffect:RIPATH_SFX_WEAPON_FIRE];
            
            [foo release];
            [data release];
        }
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
    
    [self receiveMoveCommand:gameObject destination:step];
    
    if (gameObject.position.y == _pointParams[3].y )
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
    
    gameObject.flipY = YES;
    float rotation = [RIPlanEnemy angleInDegreesBetweenSelfPoint:gameObject.position andOtherPoint:desiredPosition];
    
    if (rotation == -1)
    {
        rotation = gameObject.rotation;
    }
    
    gameObject.rotation = rotation;
    
    if (_isTargetCaged)
    {
        [self restrictTargetToCage:gameObject desiredPosition: &desiredPosition];
    }
    
    [self handleRollForDesiredPosition:offsetPosition gameObject:gameObject];
    
    gameObject.position = desiredPosition;
}

@end
