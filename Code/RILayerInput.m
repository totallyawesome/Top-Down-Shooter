//
//  RIInputLayer.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIController.h"
#import "RILayerInput.h"
#import "RIFileManager.h"

@implementation RILayerInput
@synthesize currentCommandSet = _currentCommandSet;

static RILayerInput* instanceofLayerInput;
+(RILayerInput*) sharedLayerInput
{
    NSAssert(instanceofLayerInput != nil, @"LayerInput instance not yet initialized!");
	return instanceofLayerInput;
}

+(RILayerInput*)layerWithGameData:(GDataXMLDocument *)gameData
{
    return [[[self alloc]initInputLayerWithGameData:gameData]autorelease];
}

-(id)initInputLayerWithGameData:(GDataXMLDocument*)gameData
{
    if (self = [super init])
    {
        _controllers = [[NSMutableDictionary alloc]init];
        _currentController = nil;
        _currentCommandSet = [[NSMutableArray alloc]init];
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        GDataXMLElement *inputConfiguration = [[gameData nodesForXPath:RIXPATH_INPUT error:nil]objectAtIndex:0];
        
        NSArray* controllerConfigurations = [inputConfiguration elementsForName:RIKEY_CONTROLLER];
        
        for(GDataXMLElement* controllerConfiguration in controllerConfigurations)
        {
            NSAutoreleasePool* innerPool = [[NSAutoreleasePool alloc]init];
            
            NSString* controlIdentifier = [[controllerConfiguration attributeForName:RIKEY_SHOW]stringValue];

            RIController* controller = [RIController controllerWithConfiguration:controllerConfiguration];
            [controller hideControls];
            
            [_controllers setObject:controller forKey:controlIdentifier];
            
            [innerPool drain];
        }
        
        
        [pool drain];
        
        instanceofLayerInput = self;
    }
    
    return self;
}

-(void)dealloc
{
    [_controllers removeAllObjects];
    [_controllers release];
    _controllers = nil;
    
    [_currentController release];
    _currentController = nil;
    
    [_currentCommandSet removeAllObjects];
    [_currentCommandSet release];
    _currentCommandSet = nil;
    
    [super dealloc];
}

-(void)showControl:(NSString*)identifier
{
    [self hideAllControls];
    RIController* controller = [_controllers objectForKey:identifier];
    if (controller)
    {
        [controller showControls];
        _currentController = controller;
    }
}

-(void)hideCurrentController
{
    if (_currentController)
    {
        [_currentController hideControls];
    }
}

-(void)showCurrentController
{
    if (_currentController)
    {
        [_currentController showControls];
    }
}

-(void)hideAllControls
{
    NSEnumerator* enumerator = [_controllers keyEnumerator];
    id key;
    while (key = [enumerator nextObject])
    {
        RIController* controller = [_controllers objectForKey:key];
        [controller hideControls];
    }
    
    _currentController = nil;
}

-(void)updateCommandSet
{
    [_currentCommandSet removeAllObjects];
    
    if (_currentController)
    {
        [_currentController checkCommands:_currentCommandSet];
    }    
}

@end
