//
//  RIPlanPlayerControlled.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIGameObject.h"
#import "RIPlanPlayerControlled.h"
#import "RILayerInput.h"
#import "RICommandMove.h"
#import "RICommandFireGuns.h"
#import "RIWave.h"
#import "RIManagerObject.h"
#import "RIPlanCrash.h"
#import "RIAudioManager.h"
#import "RISceneGame.h"
#import "RIStrategyProjectile.h"
#import "RIRoleFriendSidekick.h"
#import "RIRoleEnemySidekick.h"

@implementation RIPlanPlayerControlled

-(id)initWithTarget:(id)target dismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    if (self = [super initWithTarget:target dismisser:dismisser data:data])
    {
        stage1 = stage2 = stage3 = NO;
        _isCaged = YES;
        screenSize = [[CCDirector sharedDirector]winSize];
        if (dismisser)
        {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss:) name:dismisser object:nil];
        }
        
        _isCollidable = YES;
        _timeSinceLastFire = 0;
        _strength = 1; //TODO This has to be set based upon the character
        _health = 10; //TODO Reset this to the characters health. Now it is set to 1000 for testing.
        _maxHealth = _health;
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

//TODO need to handle health appearance in stage 3
//BUG: If the plane is smoking when it is dismissed, the plane moves away but the smoke doesnt, since in stage 3, we don't handle health appearance.
-(BOOL)execute:(ccTime)delta
{
    BOOL isComplete = NO;
    RIGameObject* tar = (RIGameObject*)_target;
    
    if (!stage1) //Move plane into view, and then show controls
    {
        tar.position = CGPointMake(tar.position.x, tar.position.y+1);
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        if (tar.position.y>=winSize.height/3)
        {
            stage1 = YES;
            [[RILayerInput sharedLayerInput]hideAllControls];
            [[RILayerInput sharedLayerInput]showControl:@"h2bs"];
        }
    }
    else if(!stage2)
    {
        //Check if plane is going to crash, and do crash plan
        BOOL isGoingToCrash = [self isDamageCatastrophic];
        
        if (isGoingToCrash)
        {
            RIGameObject* gameObject = (RIGameObject*)_target;
            
            RIPlanCrash* crashPlan = [[RIPlanCrash alloc]initWithTarget:gameObject dismisser:nil data:nil];
            gameObject.plan = crashPlan;
            [crashPlan release];
            return NO;
        }
        else
        {
            [self handleHealthAppearance];
        }
        
        //Read user input and do stuff.
        NSMutableArray* commands = [RILayerInput sharedLayerInput].currentCommandSet;
        for (RICommand* command in commands)
        {
            if ([command isKindOfClass:[RICommandMove class]])
            {
                RICommandMove* moveCommand = (RICommandMove*)command;
                [self receiveMoveCommand:moveCommand gameObject:tar delta:delta];
            }
            else if([command isKindOfClass:[RICommandFireGuns class]])
            {
                if (_timeSinceLastFire == 0)
                {
                    //TODO currently _timeSinceLastFire is reset to 60. This means roughly one bullet per second which is slow. Find a way to configure this to a more acceptable value if necessary, or hard code it to some good value.
                    _timeSinceLastFire = 6;
                    NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
                    [data setObject:[NSValue valueWithCGPoint:tar.position] forKey:RIKEY_START_LOCATION];
                    [data setObject:[NSNumber numberWithFloat:tar.rotation] forKey:RIKEY_ROTATION];
                    
                    
                    Class projectileFaction;
                    if ([tar.faction isSubclassOfClass:[RIRoleFriend class]])
                    {
                        projectileFaction = [RIRoleFriendSidekick class];
                    }
                    else if([tar.faction isSubclassOfClass:[RIRoleEnemy class]])
                    {
                        projectileFaction = [RIRoleEnemySidekick class];
                    }
                    
                    RIWave* foo = [[RIWave alloc]initWithNumberOfObjects:1 faction:projectileFaction isDismissable:NO strategy:[RIStrategyProjectile class] objectName:nil spriteFrameName:RISPRITE_BULLET_SPREAD dismissNotification:nil waveData:data];

                    RIManagerObject* moo = [RIManagerObject sharedManager];
                    [moo addWaveToQueue:foo];
                    [[RIAudioManager sharedAudioManager]playSoundEffect:RIPATH_SFX_WEAPON_FIRE];
                    
                    [data release];
                    [foo release];
                }
                else
                {
                    //TODO Is there anything we need to do if we are firing too much?
                    int j=0;
                    j=j;// gets triggered only if firing too much.
                    
                }
            }
        }
        
        if (_timeSinceLastFire>0)
        {
            _timeSinceLastFire--;
        }
    }
    else if(!stage3) // Stage 3 is triggered only if the plane receives the notification to be dismissed.
    {
        [[RILayerInput sharedLayerInput]hideAllControls];
        tar.position = CGPointMake(tar.position.x, tar.position.y+1);
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        if (tar.position.y>=winSize.height)
        {
            stage3 = YES;
        }
    }
    else
    {
        isComplete = YES;
    }
    
    return isComplete;
}

-(void)dismiss:(NSNotification*)notification
{
    stage2 = YES;
}

-(void)receiveMoveCommand:(RICommandMove*)moveCommand gameObject:(RIGameObject*)gameObject delta:(ccTime)delta
{
    CGPoint desiredPosition = CGPointMake(gameObject.position.x + moveCommand.velocity.x * delta*300,
                                          gameObject.position.y + moveCommand.velocity.y*delta*300);
    CGPoint offsetPosition = moveCommand.velocity;

    if (_isCaged)
    {
        [self restrictTargetToCage:gameObject desiredPosition: &desiredPosition];
    }
    
    [self handleRollForDesiredPosition:offsetPosition gameObject:gameObject];

    gameObject.position = desiredPosition;
}

@end
