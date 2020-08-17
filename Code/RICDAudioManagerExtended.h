//
//  RICDAudioManagerExtended.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "CDAudioManager.h"

@interface CDAudioManager (SoundFix)

- (void) interruption:(NSNotification*)notification;

@end
