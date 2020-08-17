//
//  RIForceEnemySpawner.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIForceMysterious.h"
#import "RIWave.h"

@interface RIForceEnemySpawner : RIForceMysterious
{
    float _spawnInterval;
    float _lastSpawnTime;
    float _currentInterval;
    
    RIWave* _wave;
}
@end
