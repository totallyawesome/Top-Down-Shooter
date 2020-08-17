//
//  RIForceFactory.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIFactoryForce.h"

@implementation RIFactoryForce

+(id)forceFactory:(GDataXMLElement*)configuration
{
    Class forceType = NSClassFromString([[configuration attributeForName:RIKEY_TYPE]stringValue]);
    
    return [forceType forceWithConfiguration:configuration];
}

@end
