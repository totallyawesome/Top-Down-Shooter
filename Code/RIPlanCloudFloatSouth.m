//
//  RIPlanCloudFloatSouth.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlanCloudFloatSouth.h"
#import "RIGameObject.h"

@implementation RIPlanCloudFloatSouth

-(id)initWithTarget:(id)target dismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    if (self = [super initWithTarget:target dismisser:dismisser data:data])
    {
        _floatRate = [[data objectForKey:RIKEY_FLOAT_RATE]floatValue];
    }
    
    return self;
}

-(BOOL)execute:(ccTime)delta
{
    BOOL isComplete = NO;

    RIGameObject* tar = (RIGameObject*)_target;
    if (tar.position.y < 0-tar.contentSize.height*tar.scale)
    {
        isComplete = YES;
    }
    
    tar.position = CGPointMake(tar.position.x,tar.position.y - _floatRate*delta);
    
    return isComplete;
}

@end
