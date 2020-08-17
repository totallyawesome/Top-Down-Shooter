//
//  RIMysteriousForce.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommand.h"
#import "RIForceMysterious.h"
#import "RIFactoryCommand.h"

@implementation RIForceMysterious
@synthesize isActive = _isActive;
@synthesize commandTimes = _commandTimes;

+(id)forceWithConfiguration:(GDataXMLElement*)configuration
{
    return [[[self alloc]initWithForceConfiguration:configuration]autorelease];
}

-(id)initWithForceConfiguration:(GDataXMLElement*)configuration
{
    if (self = [super init])
    {
        _currentTimeIndex = -1;
        _commandTimes = [[NSMutableArray alloc]init];
        _commands = [[NSMutableDictionary alloc]init];
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        //Load the attributes for its own functioning
        
        //Load all the commands into a stack sorted by time when the command should be executed.
        //Create each command with all the parameters, and store it in a dictionary so all commands that operate at a particular time can be executed.
        NSArray* commandsXML = [configuration elementsForName:RIKEY_COMMAND];
        if (commandsXML.count>0)
        {
            _currentTimeIndex = 0;
        }
        for (GDataXMLElement* commandXML in commandsXML)
        {
            NSAutoreleasePool* forPool = [[NSAutoreleasePool alloc]init];
            
            id command = [RIFactoryCommand commandWithConfiguration:commandXML];
            
            [self insertCommand:command];
            
            [forPool drain];
        }
        
        [pool drain];
    }
    
    return self;
}

-(void)dealloc
{
    [_commands removeAllObjects];
    [_commands release];
    _commands = nil;
    
    [_commandTimes removeAllObjects];
    [_commandTimes release];
    _commands = nil;
    
    [super dealloc];
}

-(void)reset
{
    if (_commands.count > 0)
    {
        _currentTimeIndex = 0;
    }
    else 
    {
        _currentTimeIndex = -1;
    }
    _currentTimeIndex = 0;
    
    self.isActive = NO;
}

-(void)insertCommand:(RICommand*)command
{
    NSNumber* time = [NSNumber numberWithInt:command.time];
    NSMutableArray* commandsCorrespondingToTime = [_commands objectForKey:time];
    if (!commandsCorrespondingToTime)
    {
        commandsCorrespondingToTime = [[NSMutableArray alloc]init];
        [_commands setObject:commandsCorrespondingToTime forKey:time];
        [commandsCorrespondingToTime release];
    }
    
    [commandsCorrespondingToTime addObject:command];
    
    int timeIntValue = [time intValue];
    int timeIndex = 0;
    for (; timeIndex<_commandTimes.count; timeIndex++)
    {
        int currentTime = [[_commandTimes objectAtIndex:timeIndex]intValue];
        if (currentTime == timeIntValue)
        {
            //Already there, so we return
            return;
        }
        else if(currentTime > timeIntValue)
        {
            break;
        }
    }
    
    if (timeIndex < _commandTimes.count)
    {
        [_commandTimes insertObject:time atIndex:timeIndex];
    }
    else
    {
        [_commandTimes addObject:time];
    }
}

-(void)checkForCommands:(float)time
{
    if (_currentTimeIndex > -1)
    {
        while (_currentTimeIndex < _commandTimes.count)
        {
            int nextCommandTime = [[_commandTimes objectAtIndex:_currentTimeIndex]intValue];
            
            if (time >= nextCommandTime) 
            {
                if (_currentTimeIndex < _commands.count)
                {
                    NSMutableArray* commands = [_commands objectForKey:[NSNumber numberWithInt:nextCommandTime]];
                    
                    for(RICommand* command in commands)
                    {
                        [self executeCommand:command];
                    }
                    
                    _currentTimeIndex++;
                }
            }
            else 
            {
                break;
            }
        }
    }
}

-(void)executeCommand:(RICommand*)command
{
    
}

-(void)act:(ccTime)delta
{
    
}

@end
