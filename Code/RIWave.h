//
//  RIWave.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RICommon.h"
#import "GDataXMLNode.h"
#import "RIRole.h"

@interface RIWave : NSObject
{
    int _numberOfObjects;
    Class _faction;
    BOOL _isDismissable;
    Class _strategy;
    
    NSString* _objectName;
    NSString* _spriteFrameName;
    NSString* _dismissNotification;
    NSMutableDictionary* _waveData;
}

@property(nonatomic)int numberOfObjects;
@property(nonatomic)Class faction;
@property(nonatomic,copy)NSString* spriteFrameName;
@property(nonatomic,assign)Class strategy;
@property(nonatomic,assign)BOOL isDismissable;
@property(nonatomic,copy)NSString* dismissNotification;
@property(nonatomic,copy)NSString* objectName;
@property(nonatomic,retain)NSMutableDictionary* waveData;

-(void)organizeObjects:(NSMutableArray*)objects;
-(id)initWithNumberOfObjects:(int)numberOfObjects faction:(Class)faction isDismissable:(BOOL)isDismissable strategy:(Class)strategy objectName:(NSString*)objectName spriteFrameName:(NSString*)spriteFrameName dismissNotification:(NSString*)dismissNotification waveData:(NSMutableDictionary*)waveData;
-(id)initWithXML:(GDataXMLElement*)xml;

@end
