//
//  RICommand.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommand.h"

@implementation RICommand
@synthesize time = _time;
+(RICommand*)commandWithXML:(GDataXMLElement *)xml
{
    return [[[self alloc]initWithXML:xml]autorelease];
}

+(RICommand*)controlCommand
{
    return [[[self alloc]initControlCommand]autorelease];
}

-(id)initControlCommand
{
    if (self = [super init])
    {
        _time = -1;
    }
    
    return self;
}

-(id)initWithXML:(GDataXMLElement *)xml
{
    if (self = [super init])
    {
        _time = [[[xml attributeForName:RIATTRIBUTE_TIME]stringValue]intValue];
    }
    
    return self;
}

@end
