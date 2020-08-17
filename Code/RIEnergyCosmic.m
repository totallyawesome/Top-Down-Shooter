//
//  RICosmicEnergy.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIEnergyCosmic.h"
#import "RIFactoryForce.h"
#import "RIForceMysterious.h"

@implementation RIEnergyCosmic

+(RIEnergyCosmic*)energyWithMysteriousForces:(GDataXMLElement*)mysteriousForces
{
    return [[[self alloc]initWithMysteriousForces:mysteriousForces]autorelease];
}

-(id)initWithMysteriousForces:(GDataXMLElement*)mysteriousForces
{
    if (self = [super init])
    {
        _time = 0;
        _commandTimeMarkerIndex = -1;
        _mysteriousForces = [[NSMutableArray alloc]init];
        _timeCommandLookup = [[NSMutableDictionary alloc]init];
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        NSArray* configurations = [mysteriousForces elementsForName:RIKEY_FORCE];
        
        for(GDataXMLElement* configuration in configurations)
        {
            NSAutoreleasePool* forPool = [[NSAutoreleasePool alloc]init];
            id force = [RIFactoryForce forceFactory:configuration];
            
            [_mysteriousForces addObject:force];
            [self addChild:force];
            [self addForcesCommandFlagsToDictionar:force];
            
            [forPool drain];
        }
        
        [pool drain];
    }
    
    return self;
}

-(void)dealloc
{
    [_mysteriousForces removeAllObjects];
    [_mysteriousForces release];
    _mysteriousForces = nil;
    
    [_timeCommandLookup removeAllObjects];
    [_timeCommandLookup release];
    _timeCommandLookup = nil;
    
    [super dealloc];
}

-(void)reset
{
    _time = 0;
    _commandTimeMarkerIndex = -1;
    for(RIForceMysterious* force in _mysteriousForces)
    {
        [force reset];
    }
}

-(void)doStuff:(ccTime)delta
{
    _time+=delta;
    for (RIForceMysterious* force in _mysteriousForces)
    {
        [force act:delta];
    }
    
    int currentFloor = floor(_time);
    if (currentFloor>_commandTimeMarkerIndex)
    {
        _commandTimeMarkerIndex = currentFloor;
        NSMutableArray* foo = [_timeCommandLookup objectForKey:[NSNumber numberWithInt:currentFloor]];
        if (foo)
        {
            for(RIForceMysterious* force in foo)
            {
                [force checkForCommands:_time];
            }
        }
    }
}

-(void)addForcesCommandFlagsToDictionar:(RIForceMysterious*)force
{
    NSMutableArray* commandTimes = force.commandTimes;
    
    for(NSNumber* commandTime in commandTimes)
    {
        NSAutoreleasePool* forPool = [[NSAutoreleasePool alloc]init];
        
        NSMutableArray* forcesIssueingCommandsAtTheseTimes = [_timeCommandLookup objectForKey:commandTime];
        
        if (!forcesIssueingCommandsAtTheseTimes)
        {
            forcesIssueingCommandsAtTheseTimes = [[[NSMutableArray alloc]init]autorelease];
            [_timeCommandLookup setObject:forcesIssueingCommandsAtTheseTimes forKey:commandTime];
        }
        
        [forcesIssueingCommandsAtTheseTimes addObject:force];
        
        [forPool drain];
    }
}

@end
