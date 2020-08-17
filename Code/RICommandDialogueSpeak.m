//
//  RICommandDialogueSpeak.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommandDialogueSpeak.h"

@implementation RICommandDialogueSpeak
@synthesize dialogue = _dialogue;

-(id)initWithXML:(GDataXMLElement *)xml
{
    if (self = [super initWithXML:xml])
    {
        NSString* dialogue = [[xml attributeForName:RIKEY_DIALOGUE]stringValue];
        NSString* character = [[xml attributeForName:RIKEY_CHARACTER]stringValue];
        float duration = [[[xml attributeForName:RIKEY_DURATION]stringValue]floatValue];
        
        _dialogue = [[RIDialogue alloc]initWithDialogue:dialogue character:character duration:duration];
    }
    
    return self;
}

-(void)dealloc
{
    [_dialogue release];
    [super dealloc];
}

@end
