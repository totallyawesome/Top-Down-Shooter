//
//  RIObjectManager.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIRole.h"
#import "RIWave.h"

@interface RIManagerObject : CCNode
{
    NSMutableDictionary* _activeObjects;
    NSMutableArray* _inactiveObjects;
    NSMutableArray* _wakingObjects;
 
    NSMutableArray* _waves;
    
    NSMutableDictionary* _nameToObject;
    
    id _hero;
    NSMutableArray* _friends; //all player controlled characters
    NSMutableArray* _sidekicks; // all player controlled characters except the main character
    
    id _boss;
    NSMutableArray* _enemies; // all enemies
    NSMutableArray* _henchmen; //all enemies except the boss;
    
    NSMutableArray* _items;
    NSMutableArray* _scenery; //refers to non-collidable scenery like clouds
}

@property(nonatomic,readonly)id hero;
@property(nonatomic,readonly)NSMutableArray* friends;
@property(nonatomic,readonly)NSMutableArray* sidekicks;
@property(nonatomic,readonly)id boss;
@property(nonatomic,readonly)NSMutableArray* enemies;
@property(nonatomic,readonly)NSMutableArray* henchmen;

+(RIManagerObject*)sharedManager;
+(RIManagerObject*)manager;

-(void)addWaveToQueue:(RIWave*)wave;
-(void)act:(ccTime)delta;
-(void)reset;
-(BOOL)containsCharacterWithName:(NSString*)name;

@end
