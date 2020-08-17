//
//  RIStrategyBoss.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIStrategyBoss.h"
#import "RIGameObject.h"
#import "RIPlanBoss.h"

@implementation RIStrategyBoss

+(void)arrange:(NSMutableArray *)gameObjects withDismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    
    for(RIGameObject* object in gameObjects)
    {
        CGPoint begin = CGPointMake(winSize.width/2, winSize.height + object.contentSize.height /2);

        CGPoint start =begin;
        CGPoint cp1 = CGPointMake(start.x - 10 , winSize.height * .9 );
        CGPoint cp2 = CGPointMake(start.x + 10, winSize.height * .8);
        CGPoint end = CGPointMake(start.x, winSize.height * .7);
        
        [data setObject:[NSValue valueWithCGPoint:start] forKey:RIKEY_START];
        [data setObject:[NSValue valueWithCGPoint:cp1] forKey:RIKEY_CP1];
        [data setObject:[NSValue valueWithCGPoint:cp2] forKey:RIKEY_CP2];
        [data setObject:[NSValue valueWithCGPoint:end] forKey:RIKEY_END_POINT];
        
        RIPlanBoss* plan = [[RIPlanBoss alloc]initWithTarget:object dismisser:dismisser data:data];
        object.plan = plan;
        [plan release];
    }
}

@end
