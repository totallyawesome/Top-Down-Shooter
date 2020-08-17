//
//  RICommandPlayMusic.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommandPlayMusic.h"

@implementation RICommandPlayMusic
@synthesize trackName = _trackName;

-(id)initWithXML:(GDataXMLElement *)xml
{
    if (self = [super initWithXML:xml])
    {
        _trackName = [[[xml attributeForName:RIATTRIBUTE_TRACK]stringValue]copy];
    }
    
    return self;
}

-(void)dealloc
{
    [_trackName release];
    [super dealloc];
}

@end
