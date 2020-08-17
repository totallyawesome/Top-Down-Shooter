//
//  RIStrategyProjectile.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIStrategyProjectile.h"
#import "RIPlanProjectile.h"
#import "RIGameObject.h"

@implementation RIStrategyProjectile

+(void)arrange:(NSMutableArray*)gameObjects withDismisser:(NSString*)dismisser data:(NSMutableDictionary*)data
{
    CGPoint startLocation = [[data objectForKey:RIKEY_START_LOCATION]CGPointValue];
    
    for(RIGameObject* object in gameObjects)
    {
        object.position = startLocation;
        RIPlanProjectile* plan = [[RIPlanProjectile alloc]initWithTarget:object dismisser:dismisser data:data];
        object.plan = plan;
        [plan release];
    }
}

@end
