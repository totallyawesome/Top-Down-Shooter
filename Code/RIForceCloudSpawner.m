//
//  RIForceCloudSpawner.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommandForceStartSpawning.h"
#import "RICommandForceStopSpawning.h"
#import "RICommandSpawnTransitionClouds.h"
#import "RIForceCloudSpawner.h"
#import "RILayerGamePlay.h"
#import "RIManagerObject.h"
#import "RIRoleScenery.h"
#import "RIStrategyCloudFloat.h"
#import "RIStrategyCloudTransition.h"
#import "RIWave.h"

@implementation RIForceCloudSpawner

-(id)initWithForceConfiguration:(GDataXMLElement *)xml
{
    if (self = [super initWithForceConfiguration:xml])
    {
        _spawnInterval = [[[xml attributeForName:RIKEY_RATE]stringValue]floatValue];
        _maxCloudPieces = 8;
        _minCloudPieces = 5;
        _maxScale = 5;
        [self reset];
    }
    
    return self;
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
    else if([command isKindOfClass:[RICommandSpawnTransitionClouds class]])
    {
        [self spawnTransitionClouds];
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

- (void)spawnCloud:(float)floatRate scale:(float)scale cloudTextureIndex:(int)cloudTextureIndex numberOfObjects:(int)numberOfObjects strategy:(Class)strategy
{
    NSMutableDictionary* waveData = [[NSMutableDictionary alloc]init];
    [waveData setObject:[NSNumber numberWithFloat:floatRate] forKey:RIKEY_FLOAT_RATE];
    [waveData setObject:[NSNumber numberWithFloat:scale] forKey:RIKEY_SCALE];
    
    RIWave* wc = [[RIWave alloc]initWithNumberOfObjects:numberOfObjects faction:[RIRoleScenery class] isDismissable:NO strategy:strategy objectName:nil spriteFrameName:[NSString stringWithFormat:RISPRITE_CLOUD_FORMAT_STRING,cloudTextureIndex] dismissNotification:nil waveData:waveData];
    
    RIManagerObject* objectManager = [RIManagerObject sharedManager];
    [objectManager addWaveToQueue:wc];
    
    [wc release];
    [waveData release];
}

-(void)spawnRandomCloud
{
    int cloudTextureIndex = arc4random()%10 + 1;
    int numberOfObjects = arc4random() % _maxCloudPieces + _minCloudPieces;
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    float floatRate = (winSize.height/60/(3+(arc4random()%5)))*60;
    float scale = arc4random()%_maxScale + 1;
    
    [self spawnCloud:floatRate scale:scale cloudTextureIndex:cloudTextureIndex numberOfObjects:numberOfObjects strategy:[RIStrategyCloudFloat class]];
}

-(void)spawnTransitionClouds
{
    int cloudTextureIndex = 1;
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    int width = winSize.width;
    int height = winSize.height;
    
    CCSprite* sampleSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:RISPRITE_CLOUD_FORMAT_STRING,cloudTextureIndex]];
    
    int numberOfObjects = (width/sampleSprite.contentSize.width)*(height/sampleSprite.contentSize.height)*1;
    
    float floatRate =[RILayerGamePlay sharedLayerGamePlay].universe.activeSpace.scrollRate*60;
    float scale = 1 + 1;
    
    [self spawnCloud:floatRate scale:scale cloudTextureIndex:cloudTextureIndex numberOfObjects:numberOfObjects strategy:[RIStrategyCloudTransition class]];
}

-(void)act:(ccTime)delta
{
    if (self.isActive)
    {
        _currentInterval += delta;
        if (_currentInterval>_spawnInterval)
        {
            [self spawnRandomCloud];
            _currentInterval = 0;
        }
    }
}

@end
