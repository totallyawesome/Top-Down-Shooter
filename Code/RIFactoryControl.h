//
//  RIControlFactory.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "RIControl.h"

@interface RIFactoryControl : NSObject

+(RIControl*)controlWithConfiguration:(GDataXMLElement*)configuration;

@end
