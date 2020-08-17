//
//  RIPlanCharacter.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlanCharacter.h"

@implementation RIPlanCharacter

+(float) angleInDegreesBetweenSelfPoint:(CGPoint)selfPoint andOtherPoint:(CGPoint)otherPoint
{
    float offY = otherPoint.y - selfPoint.y;
    float offX = otherPoint.x - selfPoint.x;
    float angleDegrees = -1;
    
    if(offX==0 && offY==0)
    {
        angleDegrees = -1;
    }
    else if(offX==0 && offY>0)
    {
        angleDegrees = 0;
    }
    else if(offX==0 && offY<0)
    {
        angleDegrees = 180;
    }
    else if(offX>0 && offY==0)
    {
        angleDegrees = 90;
    }
    else if(offX<0 && offY==0)
    {
        angleDegrees = 270;
    }
    else if(offX<0 && offY>0)
    {
        angleDegrees = 360 - CC_RADIANS_TO_DEGREES(atanf(abs(offX/offY)));
    }
    else if(offX<0 && offY<0)
    {
        angleDegrees = 180 + CC_RADIANS_TO_DEGREES(atanf(abs(offX/offY)));
    }
    else if(offX>0 && offY<0)
    {
        angleDegrees = 180 - CC_RADIANS_TO_DEGREES(atanf(abs(offX/offY)));
    }
    else if(offX>0 && offY>0)
    {
        angleDegrees = CC_RADIANS_TO_DEGREES(atanf(abs(offX/offY)));
    }
    
    if (angleDegrees!=-1)
    {
        angleDegrees = (angleDegrees + 180);
        if (angleDegrees>360)
        {
            angleDegrees-=360;
        }
    }
    
    return angleDegrees;
}

- (void)handleRollForDesiredPosition:(CGPoint)desiredDirection gameObject:(RIGameObject*)gameObject
{
    float rad = CC_DEGREES_TO_RADIANS(gameObject.rotation);
    float adjustedForRotationX = desiredDirection.x * cosf(rad) - desiredDirection.y * sinf(rad);
    
    float rollRate = 0.04;
    
    if(adjustedForRotationX < 0.2 && adjustedForRotationX >-0.2)
    {
        if (!_isStable)
        {
            _isBanked = NO;
            _isReturned = NO;
            
            if (gameObject.scaleX >= 1)
            {
                _isStable = YES;
                [gameObject setScaleX:1];
            }
            else
            {
                gameObject.scaleX+=rollRate;
            }
        }
    }
    else
    {
        if (!_isBanked)
        {
            _isStable = NO;
            
            if (!_isReturned)
            {
                if (gameObject.scaleX >= 1)
                {
                    _isReturned = YES;
                    gameObject.scaleX=1;
                }
                else
                {
                    gameObject.scaleX+=rollRate;
                }
            }
            else if(!_isBanked)
            {
                if (gameObject.scaleX <= 0.7)
                {
                    _isBanked = YES;
                    gameObject.scaleX = 0.7;
                }
                else
                {
                    gameObject.scaleX -=rollRate;
                }
            }
        }
    }
}

- (void)restrictTargetToCage:(RIGameObject*)targetCharacter desiredPosition:(CGPoint *)desiredPosition_p
{
    int width = targetCharacter.contentSize.width;
    int height = targetCharacter.contentSize.height;
    if(desiredPosition_p->x > screenSize.width - width|| desiredPosition_p->x< width)
    {
        desiredPosition_p->x = targetCharacter.position.x;
    }
    if(desiredPosition_p->y > screenSize.height - height|| desiredPosition_p->y<height)
    {
        desiredPosition_p->y = targetCharacter.position.y;
    }
}

@end
