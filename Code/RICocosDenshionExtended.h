//
//  RICocosDenshionExtended.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CocosDenshion.h"
@interface CDSoundEngine(pauseFX)

-(void)pauseAllSounds;
-(void)resumeAllSounds;
-(int) _getSourceIndexForSourceGroup:(int)sourceGroupId;

@end
