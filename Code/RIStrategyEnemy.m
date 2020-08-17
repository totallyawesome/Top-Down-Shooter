//
//  RIStrategyEnemy.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIStrategyEnemy.h"
#import "RIPlanEnemy.h"
#import "RIGameObject.h"

@implementation RIStrategyEnemy

+(void)arrange:(NSMutableArray *)gameObjects withDismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    int sampleGameObjectWidth = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.width;
    
    int sampleGameObjectHeight = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.height;
    
    
    int startX = MIN(MAX(sampleGameObjectWidth/2, (arc4random()%(int)(winSize.width))), (winSize.width - sampleGameObjectWidth));
    CGPoint begin = CGPointMake(startX, winSize.height + sampleGameObjectHeight);
    
    
    
    int xOffset= 0;
    int yOffset = 0;
    for(RIGameObject* object in gameObjects)
    {
        CGPoint start = CGPointMake(begin.x + xOffset, begin.y + yOffset);
        CGPoint cp1 = CGPointMake(start.x + 10 , 210 + yOffset);
        CGPoint cp2 = CGPointMake(start.x - 10, 100 - yOffset);
        CGPoint end = CGPointMake(start.x, -30 - yOffset);
        
        xOffset += 5 + object.contentSize.height;
        yOffset += 5 + object.contentSize.height;
        if (xOffset >6 * object.contentSize.width)
        {
            xOffset = object.contentSize.width;
        }
        if (yOffset > 6 * object.contentSize.height)
        {
            yOffset = object.contentSize.height;
        }
        
        [data setObject:[NSValue valueWithCGPoint:start] forKey:RIKEY_START];
        [data setObject:[NSValue valueWithCGPoint:cp1] forKey:RIKEY_CP1];
        [data setObject:[NSValue valueWithCGPoint:cp2] forKey:RIKEY_CP2];
        [data setObject:[NSValue valueWithCGPoint:end] forKey:RIKEY_END_POINT];
        
        RIPlanEnemy* plan = [[RIPlanEnemy alloc]initWithTarget:object dismisser:dismisser data:data];
        object.plan = plan;
        [plan release];
    }
}

@end
