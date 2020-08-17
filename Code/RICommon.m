//
//  RICommon.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommon.h"
#import "GDataXMLNode.h"

@implementation RICommon

const float CubicLagrangePinnedKnot[4] = {0.f, 0.33f, 0.66f, 1.f};

+(NSMutableArray*)sortXmlByIndexAttribute:(NSArray*)dataArray
{    
    NSMutableArray* sorted = [self sortXmlArray:dataArray byAttribute:RIKEY_INDEX];
    
    return sorted;
}

+(NSMutableArray*)sortXmlArray:(NSArray*)dataArray byAttribute:(NSString*)attribute
{
    NSMutableArray* sorted = [[[NSMutableArray alloc]init]autorelease];
    
    for (GDataXMLElement* spaceXML in dataArray)
    {
        int spaceId = [[[spaceXML attributeForName:attribute]stringValue]intValue];
        
        int insertLocation = 0;
        for (;insertLocation<sorted.count; insertLocation++)
        {
            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
            
            GDataXMLElement* current = [sorted objectAtIndex:insertLocation];
            int currentId = [[[current attributeForName:attribute]stringValue]intValue];
            
            if (currentId > spaceId)
            {
                break;
            }
            
            [pool drain];
        }
        
        [sorted insertObject:spaceXML atIndex:insertLocation];
    }
    
    return sorted;
}

@end
