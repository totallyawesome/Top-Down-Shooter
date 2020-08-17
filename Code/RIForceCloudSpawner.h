//
//  RIForceCloudSpawner.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIForceMysterious.h"

@interface RIForceCloudSpawner : RIForceMysterious
{
    float _spawnInterval;
    float _lastSpawnTime;
    float _currentInterval;
    
    int _maxCloudPieces;
    int _minCloudPieces;
    int _maxScale;
}
@end
