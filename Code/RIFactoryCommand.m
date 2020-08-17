//
//  RIFactoryCommand.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIFactoryCommand.h"

@implementation RIFactoryCommand

+(id)commandWithConfiguration:(GDataXMLElement*)configuration
{
    Class commandType = NSClassFromString([[configuration attributeForName:RIKEY_TYPE]stringValue]);
    
    return [commandType commandWithXML:configuration];
}

+(id)controlCommandWithConfiguration:(GDataXMLElement*)configuration
{
    Class commandType = NSClassFromString([[configuration attributeForName:RIKEY_CONTROL_COMMAND]stringValue]);
    
    return [commandType controlCommand];
}

@end
