//
//  RIFileManager.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIFileManager : NSObject

+(NSString*)filePathWithinBundleForFile:(NSString*)fileNameWithExtension; 
+(NSString*)filePathWithinDocumentsForFile:(NSString*)fileNameWithExtension;

@end
