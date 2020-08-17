//
//  RICommandMove.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommand.h"

@interface RICommandMove : RICommand
{
    CGPoint _velocity;
}

@property(nonatomic,assign)CGPoint velocity;
@end
