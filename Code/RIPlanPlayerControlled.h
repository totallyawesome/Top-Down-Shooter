//
//  RIPlanPlayerControlled.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlanCharacter.h"

@interface RIPlanPlayerControlled : RIPlanCharacter
{
    BOOL stage1;
    BOOL stage2;
    BOOL stage3;
    BOOL _isCaged;
    
    int _timeSinceLastFire;
}

@end
