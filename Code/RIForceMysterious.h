//
//  RIMysteriousForce.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GDataXMLNode.h"

@interface RIForceMysterious : CCNode
{
    NSMutableDictionary* _commands;
    NSMutableArray* _commandTimes;
    int _currentTimeIndex;
    BOOL _isActive;
}

@property(nonatomic,assign)BOOL isActive;
@property(nonatomic,readonly)NSMutableArray* commandTimes;
+(id)forceWithConfiguration:(GDataXMLElement*)xml;
-(id)initWithForceConfiguration:(GDataXMLElement*)xml;

-(void)act:(ccTime)delta;
-(void)checkForCommands:(float)time;

-(void)executeCommand:(id)command;
-(void)reset;

@end
