//
//  RIButton.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIControlButton.h"

@implementation RIControlButton

-(id)initWithConfiguration:(GDataXMLElement*)configuration
{
    
    if(self = [super initWithConfiguration:configuration])
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        SneakyButton* _button = [SneakyButton button];
        _button.isHoldable = [[[configuration attributeForName:RIKEY_IS_HOLDABLE]stringValue]boolValue];
        
        float buttonXOffset = [[[configuration attributeForName:RIKEY_X_OFFSET]stringValue]floatValue];
        float buttonYOffset = [[[configuration attributeForName:RIKEY_Y_OFFSET]stringValue]floatValue];
        
        SneakyButtonSkinnedBase* tempSkinnedControl = [SneakyButtonSkinnedBase skinnedButton];
        
        tempSkinnedControl.defaultSprite = [CCSprite spriteWithSpriteFrameName:[[configuration attributeForName:RIKEY_DEFAULT_SPRITE]stringValue]];
        tempSkinnedControl.pressSprite = [CCSprite spriteWithSpriteFrameName:[[configuration attributeForName:RIKEY_PRESS_SPRITE]stringValue]];
        tempSkinnedControl.activatedSprite = [CCSprite spriteWithSpriteFrameName:[[configuration attributeForName:RIKEY_PRESS_SPRITE]stringValue]];
        tempSkinnedControl.disabledSprite = [CCSprite spriteWithSpriteFrameName:[[configuration attributeForName:RIKEY_DEFAULT_SPRITE]stringValue]];

        float buttonWidth = tempSkinnedControl.defaultSprite.contentSize.width;
        
        tempSkinnedControl.position = CGPointMake(screenSize.width - buttonWidth * buttonXOffset, buttonWidth * buttonYOffset);
        
        tempSkinnedControl.button = _button;
        _skinnedControl = tempSkinnedControl;
        [_skinnedControl retain];
        
        [pool drain];
    }
    
    return self;
}

-(RICommand*)checkCommand
{
    RICommand* command = nil;
    
    if ([[self.skinnedControl button]active])
    {
        command = _command;
    }
    
    return command;
}

@end
