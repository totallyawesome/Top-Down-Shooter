//
//  RIPlan.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RICommon.h"
@interface RIPlan : NSObject
{
    id _target;
    int _health;
    int _strength;
    int _maxHealth;
    BOOL _isCollidable;
    CCParticleSystem* _smokeSystem;
    int _timeSinceLastHealthImprovement;

    NSMutableArray* _hits;
}

@property (nonatomic,assign)int health;
@property (nonatomic,assign)int strength;
@property (nonatomic,assign)BOOL isCollidable;
@property (nonatomic,retain)NSMutableArray* hits;

-(id)initWithTarget:(id)target dismisser:(NSString*)dismisser data:(NSMutableDictionary*)data;
-(BOOL)execute:(ccTime)delta;
-(BOOL)isDamageCatastrophic;
-(void)handleHealthAppearance;

@end
