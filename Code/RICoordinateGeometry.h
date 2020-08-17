//
//  RICoordinateGeometry.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIPointIntersection.h"

@interface RICoordinateGeometry : NSObject
{
    CGSize _winSize;
}


+(RICoordinateGeometry*) sharedCoordinateGeometry;
-(CGPoint)pointOnScreenEdgeThatProjectileFirstIntersectsWith:(CGPoint)point rotation:(float)rotation;

@end
