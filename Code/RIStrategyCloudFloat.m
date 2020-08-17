//
//  RIStrategyCloudFloat.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIGameObject.h"
#import "RIPlanCloudFloatSouth.h"
#import "RIStrategyCloudFloat.h"

@implementation RIStrategyCloudFloat

+(void)arrange:(NSMutableArray*)gameObjects withDismisser:(NSString*)dismisser data:(NSMutableDictionary*)data
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    int intWidth = winSize.width;
    
    float scale = [[data objectForKey:RIKEY_SCALE]floatValue];
    float x = arc4random() % intWidth*0.8;
    float objectHeight = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.height*scale;
    float objectWidth = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.width*scale;
    float y = winSize.height + objectHeight/2;
    float lowestY = y;
    
    for(RIGameObject* object in gameObjects)
    {
        object.position = CGPointMake(x,y);
        object.rotation = arc4random()%360;
        object.scale = scale;
        
        if (y<lowestY)
        {
            lowestY = y;
        }
        
        x+= arc4random() % (int)objectWidth/2;
        y+= arc4random() % (int)objectHeight/2;
        x-= arc4random() % (int)objectWidth/2;
        y-= arc4random() % (int)objectHeight/2;

        
        RIPlanCloudFloatSouth* plan = [[RIPlanCloudFloatSouth alloc]initWithTarget:object dismisser:dismisser data:data];
        object.plan = plan;
        [plan release];
    }
    
    for (RIGameObject* object in gameObjects)
    {
        object.position = CGPointMake(object.position.x,object.position.y + (winSize.height + objectHeight/2 - lowestY));
    }
}

@end
