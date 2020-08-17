//
//  RIForceFactory.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "RICommon.h"
#import "RIForceMysterious.h"
@interface RIFactoryForce : NSObject
{
    
}

+(id)forceFactory:(GDataXMLElement*)configuration;

@end
