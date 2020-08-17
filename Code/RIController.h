//
//  RIController.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "GDataXMLNode.h"

@interface RIController : CCNode
{
    NSMutableArray* _controls;
}

@property(nonatomic,retain)NSMutableArray* controls;

+(id)controllerWithConfiguration:(GDataXMLElement*)configuration;
-(void)showControls;
-(void)hideControls;
-(void)checkCommands:(NSMutableArray*)commandSet;

@end
