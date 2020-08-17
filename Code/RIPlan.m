//
//  RIPlan.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIGameObject.h"
#import "RILayerGamePlay.h"
#import "RIPlan.h"
#import "RISceneGame.h"

@implementation RIPlan
@synthesize isCollidable = _isCollidable;
@synthesize hits = _hits;
@synthesize  health = _health;
@synthesize strength = _strength;

-(id)initWithTarget:(id)target dismisser:(NSString*)dismisser data:(NSMutableDictionary*)data
{
    if (self = [super init]) 
    {
        _target = target;
        _health = [[data objectForKey:RIKEY_HEALTH]intValue];
        _strength = [[data objectForKey:RIKEY_STRENGTH]intValue];
        _maxHealth = _health;
        _hits = [[NSMutableArray alloc]init];
        _isCollidable = NO;
    }
    
    return self;
}

-(void)dealloc
{
    [_hits removeAllObjects];
    [_hits release];
    _hits = nil;
    
    if (_smokeSystem)
    {
        [[RILayerGamePlay sharedLayerGamePlay].smokeParticleBatchNode removeChild:_smokeSystem cleanup:YES];
        _smokeSystem = nil;
    }
    
    [super dealloc];
}

-(BOOL)execute:(ccTime)delta
{
    return YES;
}

-(BOOL)isDamageCatastrophic
{
    BOOL isDead = NO;
    
    for(NSNumber* hit in _hits)
    {
        _health -= [hit intValue];
    }
    
    [_hits removeAllObjects];
    
    if (_health < 0)
    {
        isDead = YES;
        if (_smokeSystem)
        {
            [[RILayerGamePlay sharedLayerGamePlay].smokeParticleBatchNode removeChild:_smokeSystem cleanup:YES];
            _smokeSystem = nil;
        }
    }
    
    return isDead;
}

-(void)handleHealthAppearance
{
    float status = (_health*100) / _maxHealth;
    RIGameObject* tar = (RIGameObject*)_target;
    
    if (status < 50)
    {
        if (!_smokeSystem)
        {
            _smokeSystem = [CCParticleSystemQuad particleWithFile:RIPATH_TEXTURES_SMOKEPLIST];
            _smokeSystem.positionType = kCCPositionTypeGrouped;
            _smokeSystem.autoRemoveOnFinish = NO;
            _smokeSystem.position = tar.position;
            [[RILayerGamePlay sharedLayerGamePlay].smokeParticleBatchNode addChild:_smokeSystem z:tar.zOrder -1];
        }
        else
        {
            _smokeSystem.position = tar.position;
            _smokeSystem.angle = ((int)(tar.rotation + 270))%360;
        }
    }
    else if(status>=50)
    {
        if (_smokeSystem)
        {
            [[RILayerGamePlay sharedLayerGamePlay].smokeParticleBatchNode removeChild:_smokeSystem cleanup:YES];
            _smokeSystem = nil;
        }
    }
    
    if (_timeSinceLastHealthImprovement > 600)
    {
        _timeSinceLastHealthImprovement = 0;
        if (_health < _maxHealth)
        {
            _health++;
        }
    }
    
    _timeSinceLastHealthImprovement++;
}

@end
