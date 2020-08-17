//
//  RIWave.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIRoleEnemySidekick.h"
#import "RIRoleFriendHero.h"
#import "RIWave.h"
#import "RIStrategy.h"
#import "RIGameObject.h"

@implementation RIWave
@synthesize numberOfObjects = _numberOfObjects;
@synthesize faction = _faction;
@synthesize spriteFrameName = _spriteFrameName;
@synthesize strategy = _strategy;
@synthesize isDismissable = _isDismissable;
@synthesize dismissNotification = _dismissNotification;
@synthesize objectName = _objectName;
@synthesize waveData = _waveData;

-(id)initWithXML:(GDataXMLElement*)xml
{
    int numberOfObjects = [[[xml attributeForName:RIKEY_NUMBER_OF_OBJECTS]stringValue]intValue];
    Class faction = NSClassFromString([[xml attributeForName:RIKEY_FACTION]stringValue]);
    BOOL isDismissable = [[[xml attributeForName:RIKEY_IS_DISMISSABLE]stringValue]boolValue];
    Class strategy = NSClassFromString([[xml attributeForName:RIKEY_STRATEGY]stringValue]);
    NSString* objectName = [[xml attributeForName:RIKEY_OBJECT_NAME]stringValue];
    NSString* spriteFrameName = [[xml attributeForName:RIKEY_SPRITE_FRAME_NAME]stringValue];
    NSString* dismissNotification = [[xml attributeForName:RIKEY_DISMISS_NOTIFICATION]stringValue];
    
    if ([objectName length] == 0)
    {
        objectName = nil;
    }
    
    if ([spriteFrameName length] == 0) {
        spriteFrameName = nil;
    }
    
    if ([dismissNotification length] == 0)
    {
             dismissNotification = nil;
    }
    
    NSMutableDictionary* extraData = [self dictionaryFromXML:[[xml elementsForName:RIKEY_WAVE_DATA]objectAtIndex:0]];
    
    return [self initWithNumberOfObjects:numberOfObjects faction:faction isDismissable:isDismissable strategy:strategy objectName:objectName spriteFrameName:spriteFrameName dismissNotification:dismissNotification waveData:extraData];
    
}

-(id)initWithNumberOfObjects:(int)numberOfObjects faction:(Class)faction isDismissable:(BOOL)isDismissable strategy:(Class)strategy objectName:(NSString*)objectName spriteFrameName:(NSString*)spriteFrameName dismissNotification:(NSString*)dismissNotification waveData:(NSMutableDictionary*)waveData
{
    if (self = [super init])
    {
        _numberOfObjects = numberOfObjects;
        _faction = faction;
        _isDismissable = isDismissable;
        _strategy = strategy;
        
        _objectName = [objectName copy];
        _spriteFrameName = [spriteFrameName copy];
        _dismissNotification = [dismissNotification copy];
        if (waveData)
        {
            _waveData = [waveData retain];
        }
        else
        {
            _waveData = [[NSMutableDictionary alloc]init];
        }
    }
    
    return self;
}


-(void)dealloc
{
    [_spriteFrameName release];
    _spriteFrameName = nil;
    
    [_dismissNotification release];
    _dismissNotification = nil;
    
    [_waveData removeAllObjects];
    [_waveData release];
    _waveData = nil;
    
    [super dealloc];
}

-(void)organizeObjects:(NSMutableArray*)objects
{
    for(RIGameObject* gameObject in objects)
    {
        gameObject.faction = _faction;
        [gameObject setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:_spriteFrameName]];
        
        if (self.objectName)
        {
            gameObject.name = self.objectName;
        }
    }
    
    [_strategy arrange:objects withDismisser:_dismissNotification data:_waveData];
}

-(NSMutableDictionary*)dictionaryFromXML:(GDataXMLElement*)xml
{
    NSMutableDictionary* waveData = [[NSMutableDictionary alloc]init];
    NSArray* items = [xml elementsForName:@"WaveKey"];
    for (GDataXMLElement* element in items)
    {
        NSString* key = [[element attributeForName:@"key"]stringValue];
        NSString* type = [[element attributeForName:@"type"]stringValue];
        NSString* value = [[element attributeForName:@"value"]stringValue];
        
        if ([type isEqualToString:@"number"])
        {
            [waveData setObject:[NSNumber numberWithDouble:[value doubleValue]] forKey:key];
        }
        else if ([type isEqualToString:@"string"])
        {
            [waveData setObject:[value copy] forKey:key];
        }
        else if ([type isEqualToString:@"bool"])
        {
            [waveData setObject:[NSNumber numberWithBool:[value boolValue]] forKey:key];
        }
    }
    
    return [waveData autorelease];
}

@end
