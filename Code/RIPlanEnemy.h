//
//  RIPlanEnemy.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlanCharacter.h"

@interface RIPlanEnemy : RIPlanCharacter
{
    float _elapsed;
    float _duration;
    CGPoint _pointParams[4];
    BOOL _isTargetCaged;
}

@end
