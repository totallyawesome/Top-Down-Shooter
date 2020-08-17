//
//  RIControl.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIControl.h"
#import "RIFactoryCommand.h"

@implementation RIControl
@synthesize skinnedControl = _skinnedControl;

+(id)controlWithConfiguration:(GDataXMLElement *)configuration
{
    return [[[self alloc]initWithConfiguration:configuration]autorelease];
}

-(id)initWithConfiguration:(GDataXMLElement *)configuration
{
    if (self = [super init])
    {
        _command = [[RIFactoryCommand controlCommandWithConfiguration:configuration]retain];
    }
    
    return self;
}

-(void)dealloc
{
    [_skinnedControl release];
    _skinnedControl = nil;
    
    [super dealloc];
}

-(void) hide
{
    [self.skinnedControl setVisible:NO];
}

-(void) show
{
    [self.skinnedControl setVisible:YES];
}

-(RICommand*)checkCommand
{
    return nil;
}

@end
