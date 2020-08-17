//
//  RIJoystick.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIControlJoystick.h"
#import "RICommandMove.h"

@implementation RIControlJoystick

-(id)initWithConfiguration:(GDataXMLElement *)configuration
{
    if (self = [super initWithConfiguration:configuration])
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        SneakyJoystickSkinnedBase* tempSkinnedControl = [SneakyJoystickSkinnedBase skinnedJoystick];
        
        tempSkinnedControl.backgroundSprite = [CCSprite spriteWithSpriteFrameName:[[configuration attributeForName:RIKEY_BACKGROUND_SPRITE]stringValue]];
        tempSkinnedControl.thumbSprite = [CCSprite spriteWithSpriteFrameName:[[configuration attributeForName:RIKEY_THUMB_SPRITE]stringValue]];
        tempSkinnedControl.backgroundSprite.color = ccMAGENTA;
        
        float stickWidth = tempSkinnedControl.backgroundSprite.contentSize.width;
        tempSkinnedControl.position = CGPointMake(stickWidth * [[[configuration attributeForName:RIKEY_X_OFFSET]stringValue]floatValue], stickWidth * [[[configuration attributeForName:RIKEY_Y_OFFSET]stringValue]floatValue]);
        
        SneakyJoystick* _joystick = [SneakyJoystick joystickWithRect:CGRectMake(0, 0, stickWidth, stickWidth)];
        _joystick.autoCenter = [[[configuration attributeForName:RIKEY_IS_AUTO_CENTER]stringValue] boolValue];
        
        _joystick.isDPad = [[[configuration attributeForName:RIKEY_IS_D_PAD]stringValue] boolValue];
        _joystick.numberOfDirections = [[[configuration attributeForName:RIKEY_NUMBER_OF_DIRECTIONS]stringValue]intValue];
        
        tempSkinnedControl.joystick = _joystick;
        _skinnedControl = tempSkinnedControl;
        [_skinnedControl retain];
        
        [pool drain];
    }
    
    return self;
}

-(RICommand*)checkCommand
{
    RICommand* command = nil;
    
    CGPoint velocity = [[self.skinnedControl joystick]velocity];
    RICommandMove* foo = (RICommandMove*)_command;
    foo.velocity = CGPointMake(velocity.x, velocity.y);
    command = _command;
    
    return command;
}

@end
