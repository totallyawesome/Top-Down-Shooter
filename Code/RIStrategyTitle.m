//
//  RIStrategyTitle.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIGameObject.h"
#import "RIPlanTitle.h"
#import "RIStrategyTitle.h"

@implementation RIStrategyTitle

+(void)arrange:(NSMutableArray *)gameObjects withDismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    RIGameObject* gameObject = (RIGameObject*)[gameObjects objectAtIndex:0];
    RIPlanTitle* plan = [[RIPlanTitle alloc]initWithTarget:gameObject dismisser:nil data:nil];
    
    gameObject.plan = plan;
    [plan release];
}

@end
