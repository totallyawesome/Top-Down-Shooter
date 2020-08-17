//
//  RIStrategy.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.s
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RICommon.h"

@interface RIStrategy : NSObject

+(void)arrange:(NSMutableArray*)gameObjects withDismisser:(NSString*)dismisser data:(NSMutableDictionary*)data;

@end
