//
//  RIForceMakeSpecialCharacter.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommandCreateSpecialCharacter.h"
#import "RICommandDismissSpecialCharacter.h"
#import "RIForceManageSpecialCharacter.h"
#import "RIManagerObject.h"

//TODO need to make sure that gameobject stores its name and that object manager is aware of it.
@implementation RIForceManageSpecialCharacter

-(id)initWithForceConfiguration:(GDataXMLElement *)xml
{
    if (self = [super initWithForceConfiguration:xml])
    {
        GDataXMLElement* waveXml = [[xml elementsForName:RIKEY_WAVE]objectAtIndex:0];
        _wave = [[RIWave alloc]initWithXML:waveXml];
    }
    
    return self;
}

-(void)dealloc
{
    [_wave release];
    _wave = nil;
    
    [super dealloc];
}

-(void)executeCommand:(id)command
{
    if ([command isKindOfClass:[RICommandCreateSpecialCharacter class]])
    {
        [self createSpecialCharacter];
    }
    else if([command isKindOfClass:[RICommandDismissSpecialCharacter class]])
    {
        [self dismissSpecialCharacter];
    }
    else
    {
        CCLOG(@"Command not recognized");
    }
}

-(void)createSpecialCharacter
{
    RIManagerObject* objectManager = [RIManagerObject sharedManager];
    if (![objectManager containsCharacterWithName:_wave.objectName])
    {
        [objectManager addWaveToQueue:_wave];
    }
}

-(void)dismissSpecialCharacter
{
    [[NSNotificationCenter defaultCenter]postNotificationName:_wave.dismissNotification object:self];
}

@end
