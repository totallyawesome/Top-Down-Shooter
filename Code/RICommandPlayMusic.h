//
//  RICommandPlayMusic.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommand.h"

@interface RICommandPlayMusic : RICommand
{
    NSString* _trackName;
}

@property (nonatomic,readonly)NSString* trackName;
@end
