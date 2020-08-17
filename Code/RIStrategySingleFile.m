//
//  RIStrategySingleFile.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIGameObject.h"
#import "RIManagerObject.h"
#import "RIPlanEnemy.h"
#import "RIStrategySingleFile.h"

@implementation RIStrategySingleFile

+(void)arrange:(NSMutableArray *)gameObjects withDismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    BOOL towardsPlayer = [[data objectForKey:RIKEY_TOWARDS_PLAYER]boolValue];
    BOOL inlineWithPlayer = [[data objectForKey:RIKEY_INLINE_WITH_PLAYER]boolValue];
    BOOL isFromBelow = [[data objectForKey:RIKEY_IS_FROM_BELOW]boolValue];
    
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    int sampleGameObjectWidth = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.width;
    
    int sampleGameObjectHeight = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.height;
    
    RIGameObject* hero = [[RIManagerObject sharedManager]hero];
    
    int startX,finishX;
    
    if (inlineWithPlayer)
    {
        if (hero)
        {
            startX = hero.position.x;
        }
        else
        {
            startX = MAX(sampleGameObjectWidth/2, (arc4random()%(int)(winSize.width - sampleGameObjectWidth/2)));
        }
    }
    else
    {
        startX = MAX(sampleGameObjectWidth/2, (arc4random()%(int)(winSize.width - sampleGameObjectWidth/2)));
    }
    
    if (towardsPlayer)
    {
        if (hero)
        {
            finishX = hero.position.x;
        }
        else
        {
            finishX = MAX(sampleGameObjectWidth/2, (arc4random()%(int)(winSize.width - sampleGameObjectWidth/2)));
        }
    }
    else
    {
        finishX = MAX(sampleGameObjectWidth/2, (arc4random()%(int)(winSize.width - sampleGameObjectWidth/2)));
    }
    
    [self bindObjectsToPlanWithStart:startX finishX:finishX gameObjects:gameObjects sampleGameObjectHeight:sampleGameObjectHeight winSize:winSize data:data dismisser:dismisser fromBelow:isFromBelow];
}

+ (void)bindObjectsToPlanWithStart:(int)startX finishX:(int)finishX gameObjects:(NSMutableArray *)gameObjects sampleGameObjectHeight:(int)sampleGameObjectHeight winSize:(CGSize)winSize data:(NSMutableDictionary *)data dismisser:(NSString *)dismisser fromBelow:(BOOL)isFromBelow
{
    int diff = finishX - startX;
    
    CGPoint begin = CGPointMake(startX, winSize.height + sampleGameObjectHeight*gameObjects.count);
    
    
    int yOffset = 0;
    for(RIGameObject* object in gameObjects)
    {
        CGPoint start = CGPointMake(begin.x, begin.y - yOffset);
        CGPoint cp1 = CGPointMake(begin.x + (diff)*0.33 , begin.y*0.66 - yOffset);
        CGPoint cp2 = CGPointMake(begin.x + (diff)*0.66, begin.y*0.33 - yOffset);
        CGPoint end = CGPointMake(finishX, - object.contentSize.height - yOffset);
        
        yOffset += 5 + object.contentSize.height;
        
        
        if (!isFromBelow)
        {
            [data setObject:[NSValue valueWithCGPoint:start] forKey:RIKEY_START];
            [data setObject:[NSValue valueWithCGPoint:cp1] forKey:RIKEY_CP1];
            [data setObject:[NSValue valueWithCGPoint:cp2] forKey:RIKEY_CP2];
            [data setObject:[NSValue valueWithCGPoint:end] forKey:RIKEY_END_POINT];
        }
        else
        {
            [data setObject:[NSValue valueWithCGPoint:end] forKey:RIKEY_START];
            [data setObject:[NSValue valueWithCGPoint:cp2] forKey:RIKEY_CP1];
            [data setObject:[NSValue valueWithCGPoint:cp1] forKey:RIKEY_CP2];
            [data setObject:[NSValue valueWithCGPoint:start] forKey:RIKEY_END_POINT];
        }

        
        RIPlanEnemy* plan = [[RIPlanEnemy alloc]initWithTarget:object dismisser:dismisser data:data];
        object.plan = plan;
        [plan release];
    }
}

@end
