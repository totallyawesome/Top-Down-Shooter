//
//  RIForceCreditSpawner.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommandSpawnTitle.h"
#import "RIForceCreditSpawner.h"
#import "RIManagerObject.h"
#import "RIRoleScenery.h"
#import "RIStrategyTitle.h"
#import "RIWave.h"

@implementation RIForceCreditSpawner

-(void)executeCommand:(id)command
{
    if ([command isKindOfClass:[RICommandSpawnTitle class]])
    {
        [self spawnTitle];
    }
}

-(void)spawnTitle
{
    RIWave* wave = [[RIWave alloc]initWithNumberOfObjects:1 faction:[RIRoleScenery class] isDismissable:NO strategy:[RIStrategyTitle class] objectName:nil spriteFrameName:RISPRITE_ONE_PIX dismissNotification:nil waveData:nil];
    
    [[RIManagerObject sharedManager]addWaveToQueue:wave];
    [wave release];
}

@end
