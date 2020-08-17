//
//  RIController.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIController.h"
#import "RIFactoryControl.h"
#import "RILayerGamePlay.h"

@implementation RIController
@synthesize controls = _controls;

+(id)controllerWithConfiguration:(GDataXMLElement*)configuration
{
    return [[[self alloc]initWithConfiguration:configuration]autorelease];
}

-(id)initWithConfiguration:(GDataXMLElement*)configuration
{
    if (self = [super init])
    {
        _controls = [[NSMutableArray alloc]init];
        
        NSArray* controlConfigurations = [configuration elementsForName:RIELEMENT_CONTROL];
        
        for(GDataXMLElement* controlConfiguration in controlConfigurations)
        {
            RIControl* control = [RIFactoryControl controlWithConfiguration:controlConfiguration];
            
            //TODO Figure out z-ordering
            [[RILayerGamePlay sharedLayerGamePlay] addChild:control.skinnedControl z:RIZorderInputLayerControls];
            [_controls addObject:control];
        }
    }
    
    return self;
}

-(void)dealloc
{
    [_controls removeAllObjects];
    [_controls release];
    _controls = nil;
    
    [super dealloc];
}

-(void)showControls
{
    //Loop through all the controls in the controls array, and make them visible
    int count = [self.controls count];
    for (int i=0; i<count; i++)
    {
        [[self.controls objectAtIndex:i] show];
    }    
}

-(void)hideControls
{
    //Loop through all the controls in the controls array, and hide them.
    [self unscheduleUpdate];
    
    int count = [self.controls count];
    for (int i=0; i<count; i++)
    {
        [[self.controls objectAtIndex:i] hide];
    }
}

-(void)checkCommands:(NSMutableArray*)commandSet;
{    
    for(RIControl* control in _controls)
    {
        RICommand* command = [control checkCommand];
        if (command)
        {
            [commandSet addObject:command];
        }
    }    
}

@end
