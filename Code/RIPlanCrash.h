//
//  RIPlanCrash.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlan.h"
#import "ShatteredSprite.h"

@interface RIPlanCrash : RIPlan
{
    BOOL _isStartedExploding;
    BOOL _isFinishedExploding;
    ShatteredSprite* _shattered;
    int _frameCount;
    CCParticleSystem* _system;
}
@end
