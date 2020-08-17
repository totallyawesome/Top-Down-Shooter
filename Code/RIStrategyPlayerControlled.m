//
//  RIStrategyPlayerControlled.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIGameObject.h"
#import "RIStrategyPlayerControlled.h"
#import "RIPlanPlayerControlled.h"

@implementation RIStrategyPlayerControlled

+(void)arrange:(NSMutableArray*)gameObjects withDismisser:(NSString*)dismisser data:(NSMutableDictionary*)data
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    int intWidth = winSize.width;
    
    for(RIGameObject* object in gameObjects)
    {
        float xStart = arc4random() % intWidth*0.8 + object.contentSize.width;
        float yStart = 0 - object.contentSize.height;
        
        if (xStart> intWidth - object.contentSize.width)
        {
            xStart -= object.contentSize.width;
        }
        
        object.position = CGPointMake(xStart,yStart);
        
        RIPlanPlayerControlled* plan = [[RIPlanPlayerControlled alloc]initWithTarget:object dismisser:dismisser data:data];
        object.plan = plan;
        [plan release];
    }
}
@end
