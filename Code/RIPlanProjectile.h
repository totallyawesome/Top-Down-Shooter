//
//  RIPlanProjectile.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlan.h"

@interface RIPlanProjectile : RIPlan
{
    CGPoint _pointParams[4];
    float _elapsed;
    float _duration;
}
@end
