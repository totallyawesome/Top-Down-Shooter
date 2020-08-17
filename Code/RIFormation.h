//
//  RIFormation.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIDoubleDimensionArray.h"

@interface RIFormation : NSObject

+(RIDoubleDimensionArray*)generateFormation:(RIDoubleDimensionArray*)matrix;
+(void)fillColumn:(int)column row:(int)row matrix:(RIDoubleDimensionArray *)matrix;
+(void)unFillColumn:(int)column row:(int)row matrix:(RIDoubleDimensionArray *)matrix;

@end
