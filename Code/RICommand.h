//
//  RICommand.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RICommon.h"
#import "GDataXMLNode.h"

@interface RICommand : NSObject
{
    int _time;
}

@property(nonatomic,readonly)int time;
+(RICommand*)commandWithXML:(GDataXMLElement*)xml;
+(RICommand*)controlCommand;
-(id)initWithXML:(GDataXMLElement*)xml;

@end
