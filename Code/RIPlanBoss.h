//
//  RIPlanBoss.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlanCharacter.h"

@interface RIPlanBoss : RIPlanCharacter
{
    float _elapsed;
    float _duration;
    CGPoint _pointParams[4];
    BOOL _isTargetCaged;
    
    BOOL _stage1Complete;
    BOOL _stage2Complete;
    BOOL _stage3Complete;
}

@property(atomic,retain)CCFiniteTimeAction* rollAction;

@end
