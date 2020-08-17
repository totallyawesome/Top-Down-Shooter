//
//  RIForceEnemySpawner.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIForceEnemySpawner.h"
#import "RICommandForceStartSpawning.h"
#import "RICommandForceStopSpawning.h"
#import "RIWave.h"
#import "RIManagerObject.h"

@implementation RIForceEnemySpawner

-(id)initWithForceConfiguration:(GDataXMLElement *)xml
{
    if (self = [super initWithForceConfiguration:xml])
    {
        _spawnInterval = [[[xml attributeForName:RIKEY_RATE]stringValue]floatValue];        
        GDataXMLElement* waveXML = [[xml elementsForName:RIKEY_WAVE]objectAtIndex:0];
        _wave = [[RIWave alloc]initWithXML:waveXML];
        
        [self reset];
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
    if ([command isKindOfClass:[RICommandForceStartSpawning class]])
    {
        [self startSpawning];
    }
    else if([command isKindOfClass:[RICommandForceStopSpawning class]])
    {
        [self stopSpawning];
    }
    else
    {
        CCLOG(@"Command not recognized");
    }
}

-(void)startSpawning
{
    self.isActive = YES;
}

-(void)stopSpawning
{
    self.isActive = NO;
}

-(void)reset
{
    _lastSpawnTime = 0;
    _currentInterval = 0;
    
    [super reset];
}

-(void)spawn
{    
    RIManagerObject* objectManager = [RIManagerObject sharedManager];
    [objectManager addWaveToQueue:_wave];    
}

-(void)act:(ccTime)delta
{
    if (self.isActive)
    {
        _currentInterval += delta;
        if (_currentInterval>_spawnInterval)
        {
            [self spawn];
            _currentInterval = 0;
        }
    }
}

@end
