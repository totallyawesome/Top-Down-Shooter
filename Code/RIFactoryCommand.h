//
//  RIFactoryCommand.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "RICommand.h"

@interface RIFactoryCommand : NSObject

+(id)commandWithConfiguration:(GDataXMLElement*)configuration;
+(id)controlCommandWithConfiguration:(GDataXMLElement*)configuration;

@end
