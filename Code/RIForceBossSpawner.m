//
//  RIForceBossSpawner.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommandSpawnBoss.h"
#import "RIForceBossSpawner.h"
#import "RIManagerObject.h"
#import "RIRoleEnemyBoss.h"
#import "RIStrategyBoss.h"
#import "RIWave.h"

@implementation RIForceBossSpawner

-(id)initWithForceConfiguration:(GDataXMLElement *)xml
{
    if (self = [super initWithForceConfiguration:xml])
    {
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
    if ([command isKindOfClass:[RICommandSpawnBoss class]])
    {
        [self spawnBoss];
    }
    else
    {
        CCLOG(@"Command not recognized");
    }
}

-(void)spawnBoss
{
    //TODO change this to read from GameData.xml
//    RIWave* wc = [[RIWave alloc]initWithNumberOfObjects:1 faction:[RIRoleEnemyBoss class] isDismissable:NO strategy:[RIStrategyBoss class] objectName:nil spriteFrameName:@"Boeing F13A.png" dismissNotification:nil waveData:nil];
    
    RIManagerObject* objectManager = [RIManagerObject sharedManager];
    [objectManager addWaveToQueue:_wave];
    
//    [wc release];    
}

@end
