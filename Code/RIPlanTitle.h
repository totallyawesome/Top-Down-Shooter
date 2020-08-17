//
//  RIPlanTitle.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlan.h"

@interface RIPlanTitle : RIPlan
{
    CCLabelBMFont* _title;
    BOOL _hoverComplete;
    float _hoverCounter;
    float _endHeight;
    float _scrollRate;
}

@end
