//
//  RIControl.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "ColoredCircleSprite.h"
#import "GDataXMLNode.h"
#import "RICommand.h"
#import "RICommon.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"

@interface RIControl : CCNode
{
    id _skinnedControl;
    RICommand* _command;
}

@property (nonatomic, retain) id skinnedControl;
+(id)controlWithConfiguration:(GDataXMLElement*)configuration;
-(id)initWithConfiguration:(GDataXMLElement*)configuration;

-(void)hide;
-(void)show;
-(RICommand*)checkCommand;

@end
