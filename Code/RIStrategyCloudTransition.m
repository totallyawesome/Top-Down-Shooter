//
//  RIStrategyCloudTransition.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIGameObject.h"
#import "RIPlanCloudFloatSouth.h"
#import "RIStrategyCloudTransition.h"

@implementation RIStrategyCloudTransition

+(void)arrange:(NSMutableArray *)gameObjects withDismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];    
    float scale = [[data objectForKey:RIKEY_SCALE]floatValue];
    float objectHeight = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.height*scale;
    float objectWidth = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.width*scale;
    
    float x = 0;
    float y = winSize.height + objectHeight/2;
    
    for(RIGameObject* object in gameObjects)
    {
        object.position = CGPointMake(x,y);
        object.rotation = arc4random()%360;
        object.scale = scale;
        
        x+= objectWidth/2;
        if (x>winSize.width)
        {
            x=0;
            y+= objectHeight/2;
            
            if (y>1.3*winSize.height)
            {
                y = winSize.height;
            }
        }
        
        RIPlanCloudFloatSouth* plan = [[RIPlanCloudFloatSouth alloc]initWithTarget:object dismisser:dismisser data:data];
        object.plan = plan;
        [plan release];
    }
}

@end
