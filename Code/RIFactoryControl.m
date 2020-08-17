//
//  RIControlFactory.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIFactoryControl.h"

@implementation RIFactoryControl

+(RIControl*)controlWithConfiguration:(GDataXMLElement*)configuration
{
    Class type = NSClassFromString([[configuration attributeForName:RIKEY_TYPE]stringValue]);
    
    return [type controlWithConfiguration:configuration];
}

@end
