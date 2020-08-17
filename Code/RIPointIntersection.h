//
//  RIPointIntersection.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIPointIntersection : NSObject
{
    BOOL _doesIntersect;
    CGPoint _point;
}

@property (nonatomic,assign) BOOL doesIntersect;
@property (nonatomic,assign) CGPoint point;
@end
