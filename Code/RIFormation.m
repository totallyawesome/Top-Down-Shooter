//
//  RIFormation.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIFormation.h"

@implementation RIFormation

+(RIDoubleDimensionArray*)generateFormation:(RIDoubleDimensionArray*)matrix
{
    int start = (matrix.columns/2);
    int end =   start;
    
    if (matrix.columns%2 == 0)
    {
        start--;
    }
    
    for (int row = 0; row<matrix.rows; row++)
    {
        for (int column = 0; column<matrix.columns; column++)
        {
            if (column>=start && column <=end)
            {
                [self fillColumn:column row:row matrix:matrix];
            }
        }
        
        start--;
        end++;
    }
    
    return matrix;
}

+ (void)fillColumn:(int)column row:(int)row matrix:(RIDoubleDimensionArray *)matrix
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    
    NSNumber* foo = [NSNumber numberWithInt:1];
    [matrix putObject:foo row:row column:column];
    
    [pool drain];
}

+ (void)unFillColumn:(int)column row:(int)row matrix:(RIDoubleDimensionArray *)matrix
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
    
    [matrix putObject:[NSNull null] row:row column:column];
    
    [pool drain];
}

@end
