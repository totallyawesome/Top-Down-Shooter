//
//  RIBackground.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"

@interface RIBackground : CCNode
{
    NSString* _imageName;
    CCSprite* _backgroundImage;
    NSLock* _lock;
    
    BOOL _loadBackgroundCalled;
    BOOL _loadedSprite;
}

+(RIBackground*) backgroundWithSpriteName:(NSString*)imageName;
-(void)loadBackgroundAsync:(BOOL)loadAsync;
-(void)unloadBackground;

@end
