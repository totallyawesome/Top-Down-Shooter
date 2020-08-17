//
//  RITransitionFromBlack.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RITransitionFromBlack.h"

@implementation RITransitionFromBlack
-(id)init
{
    if (self = [super initWithColor:ccc4(0, 0, 0, 255)])
    {
        self.opacity = 255;
        
    }
    
    return self;
}

-(BOOL)transition:(ccTime)delta
{
    BOOL isComplete = NO;
    
    
    if(self.opacity>4)
    {
        self.opacity = self.opacity - 4;
    }
    else if(self.opacity>0)
    {
        self.opacity = self.opacity - 1;
    }
    else
    {
        isComplete = YES;
    }
    
    return isComplete;
}

-(void)reset
{
    self.opacity = 255;
}
@end
