//
//  RIFileManager.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "RIFileManager.h"

@implementation RIFileManager

+(NSString*)filePathWithinBundleForFile:(NSString*)fileNameWithExtension 
{
    return [CCFileUtils fullPathFromRelativePath:fileNameWithExtension];
}

+(NSString*)filePathWithinDocumentsForFile:(NSString*)fileNameWithExtension
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [[documentsDirectory stringByAppendingPathComponent:fileNameWithExtension]retain];
    
    [pool drain];
    
    return [documentsPath autorelease];
}

@end
