//
//  RITransition.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "CCLayer.h"

@interface RITransition : CCLayerColor
{
    
}

-(BOOL)transition:(ccTime)delta;
-(void)reset;
@end
