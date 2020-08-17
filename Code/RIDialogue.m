//
//  RIDialogue.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIDialogue.h"

@implementation RIDialogue
@synthesize duration = _duration;
@synthesize dialogue = _dialogue;
@synthesize character = _character;

-(id)initWithDialogue:(NSString*)dialogue character:(NSString*)character duration:(float)duration
{
    if (self = [super init])
    {
        _dialogue = [dialogue copy];
        _character = [character copy];
        _duration = duration;
    }
    
    return self;
}

-(void)dealloc
{
    [_dialogue release];
    [_character release];
    [super dealloc];
}
@end
