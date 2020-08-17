//
//  RIAppDelegate.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RIViewController;

@interface RIAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow			*_window;
	RIViewController	*_viewController;
    BOOL _hasLaunchedBefore;
}

@end
