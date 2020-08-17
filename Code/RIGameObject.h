//
//  RIGameObject.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "RICommon.h"
#import "RIPlan.h"

@interface RIGameObject : CCSprite
{
    Class _faction;
    RIPlan* _plan;
    NSString* _name;
    BOOL _isActive;
}

@property(atomic)Class faction;
@property(atomic,retain)RIPlan* plan;
@property(atomic,copy)NSString* name;

+(RIGameObject*)gameObject;
-(void)activate;
-(BOOL)executePlan:(ccTime)delta;
-(void)reset;

@end
