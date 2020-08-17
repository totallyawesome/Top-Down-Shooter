//
//  RICosmicEnergy.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GDataXMLNode.h"

@interface RIEnergyCosmic : CCNode
{
    NSMutableArray* _mysteriousForces;
    NSMutableDictionary* _timeCommandLookup;

    float _time;
    int _commandTimeMarkerIndex;
}

+(RIEnergyCosmic*)energyWithMysteriousForces:(GDataXMLElement*)mysteriousForces;
-(id)initWithMysteriousForces:(GDataXMLElement*)mysteriousForces;

-(void)doStuff:(ccTime)delta;
-(void)reset;

@end
