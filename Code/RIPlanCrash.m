//
//  RIPlanCrash.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RILayerGamePlay.h"
#import "RIPlanCrash.h"
#import "RIGameObject.h"
#import "RISceneGame.h"
#import "RIRoleFriendHero.h"
#import "RIAudioManager.h"

@implementation RIPlanCrash

-(id)initWithTarget:(id)target dismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    if (self = [super initWithTarget:target dismisser:dismisser data:data])
    {
        RIGameObject* gameObject = (RIGameObject*)target;
        gameObject.scaleX = 1;
        gameObject.scaleY = 1;
        _frameCount = 0;
        _isCollidable = NO;
        _isStartedExploding = NO;
        _isFinishedExploding = NO;
        _system = nil;
    }
    
    return self;
}

-(void)dealloc
{
    if (_system)
    {
        if([_system isRunning])
        [_system stopSystem];
        [_system.parent removeChild:_system cleanup:YES];
    }
    [[RISceneGame sharedSceneGame]removeChild:_shattered cleanup:YES];
    [super dealloc];
}

-(BOOL)execute:(ccTime)delta
{
    BOOL isComplete = NO;
    
    RIGameObject* gameObject = (RIGameObject*)_target;
    
    if (!_isStartedExploding)
    {
        _isStartedExploding = YES;
        
        [gameObject setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:RISPRITE_ONE_PIX]];

        
        _system = [CCParticleSystemQuad particleWithFile:RIPATH_TEXTURES_EXPLOSIONPLIST];
        _system.positionType = kCCPositionTypeRelative;
        _system.autoRemoveOnFinish = NO;
        _system.position = gameObject.position;
        
        //TODO do we need a specific Z-order for the explosion?
        [[RILayerGamePlay sharedLayerGamePlay].explosionsParticleBatchNode addChild:_system];
        [[RIAudioManager sharedAudioManager]playSoundEffect:RIPATH_SFX_PLANE_EXPLODE];

    }
    else if(!_isFinishedExploding)
    {
        _system.position = gameObject.position;
        _frameCount++;
                
        if (_frameCount > 10)
        {
            _isFinishedExploding = YES;
        }
    }
    else
    {
        isComplete = YES;
        
        RIGameObject* gameObject = (RIGameObject*)_target;
        if ([gameObject.faction isSubclassOfClass:[RIRoleFriendHero class]])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DEAD_HERO object:nil];
        }
    }
    
    return isComplete;
}


@end
