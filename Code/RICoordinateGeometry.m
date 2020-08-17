//
//  RICoordinateGeometry.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICoordinateGeometry.h"
#import "cocos2d.h"

@implementation RICoordinateGeometry

static RICoordinateGeometry* instanceOfCoordinateGeometry;
+(RICoordinateGeometry*) sharedCoordinateGeometry
{
    if (instanceOfCoordinateGeometry == nil)
    {
        instanceOfCoordinateGeometry = [[RICoordinateGeometry alloc]init];
    }
    
    return instanceOfCoordinateGeometry;
}

-(id)init
{
    if (self = [super init])
    {
        _winSize =[[CCDirector sharedDirector]winSize];
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

//Assuming that the input rotation does not already apply the offset i.e rotation = (90-inputRotation)
-(CGPoint)pointOnScreenEdgeThatProjectileFirstIntersectsWith:(CGPoint)point rotation:(float)rotation
{    
    float offSet = 90;
    float angle = offSet - rotation;
    float rad = angle * M_PI/180;
    CGPoint destination = point;
    CGPoint vector = ccpForAngle(rad);
    CGPoint jump;
    
    vector = CGPointMake(((float)((int)(vector.x*1000)))/1000, ((float)((int)(vector.y*1000)))/1000);
    float guessX = -1;
    float guessY = -1;
    if (vector.x < 0)
    {
        guessX = abs(destination.x / vector.x);
    }
    else if(vector.x>0)
    {
        guessX = (_winSize.width - destination.x)/vector.x;
    }
    
    if (vector.y < 0)
    {
        guessY = abs(destination.y / vector.y);
    }
    else if(vector.y>0)
    {
        guessY = (_winSize.height - destination.y)/vector.y;
    }
    
    if (guessX>guessY)
    {
        if (guessY >1)
        {
            jump = ccpMult(vector, guessX - 1);
        }
    }
    else
    {
        if (guessY > 1)
        {
            jump = ccpMult(vector, guessY - 1);
        }
    }
    
    destination = ccpAdd(destination, jump);
    
    while (![self checkIfOffScreen:destination])
    {
        destination = ccpAdd(destination, vector);
    }

    return destination;
}

-(bool) checkIfOffScreen:(CGPoint)position
{
    bool isOffScreen = NO;
    
    if(position.y > _winSize.height || position.y<0 || position.x < 0 ||  position.x > _winSize.width)
    {
        isOffScreen = YES;
    }
    
    return isOffScreen;
}

@end
