//
//  RIDoubleDimensionArray.m
//  ProjectX
//
//  Created by Rahul Iyer on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RIDoubleDimensionArray.h"
#import "cocos2d.h"

@implementation RIDoubleDimensionArray
@synthesize rows = _rows;
@synthesize columns = _columns;
@synthesize contents = _contents;

+(RIDoubleDimensionArray*) arrayWithRows:(int)rows Columns:(int)columns
{
    return [[[self alloc]initWithRows:rows Columns:columns]autorelease];
}

-(id)initWithRows:(int)rows Columns:(int)columns
{
    if (self = [super init]) 
    {
        _contents = [[NSMutableArray alloc]init];
        _rows = rows;
        _columns = columns;
        
        for (int i=0; i<columns; i++)
        {
            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
            
            NSMutableArray* column = [[[NSMutableArray alloc]init]autorelease];
            
            for (int j=0; j<rows; j++)
            {
                NSAutoreleasePool* innerPool = [[NSAutoreleasePool alloc]init];
                
                [column addObject:[NSNull null]];
                
                [innerPool drain];
            }
            
            [_contents addObject:column];
            
            [pool drain];
        }
    }
    
    return self;
}

-(void)dealloc
{
    @synchronized(_contents)
    {
        for (int i=0; i<_columns; i++)
        {
            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
            
            NSMutableArray* columnData = [_contents objectAtIndex:i];
            [columnData removeAllObjects];
            
            [pool drain];
        }
        
        [_contents removeAllObjects];
    }
    
    [_contents release];
    _contents = nil;
    
    CCLOG(@"%s",__PRETTY_FUNCTION__);
    [super dealloc];
}

-(void)putObject:(id)object row:(int)row column:(int)column
{
    @synchronized(_contents)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        NSMutableArray* columnData = [_contents objectAtIndex:column];
        [columnData replaceObjectAtIndex:row withObject:object];
        
        [pool drain];
    }
}

-(id)getObjectWithoutRemovingFromRow:(int) row column:(int)column
{
    id object = nil;
    
    @synchronized(_contents)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        NSMutableArray* columnData = [_contents objectAtIndex:column];
        object = [[columnData objectAtIndex:row]retain];
        
        [pool drain];
    }

    return  [object autorelease];
}

-(void)removeObjectFromRow:(int)row column:(int)column
{
    @synchronized(_contents)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        NSMutableArray* columnData = [_contents objectAtIndex:column];
        [columnData replaceObjectAtIndex:row withObject:[NSNull null]];
        
        [pool drain];
    }
}

-(void) rotateMatrixAntiClockWise
{
    RIDoubleDimensionArray* result = [[RIDoubleDimensionArray alloc] initWithRows:self.columns Columns:self.rows];
    
    int fooRow = 0;
    int fooCol = 0;
    
    for (int col = self.rows -1; col>=0; col--) 
    {
        for (int row = 0; row<self.columns; row++) 
        {
            id object = [self getObjectWithoutRemovingFromRow:fooRow column:fooCol];
            
            [result putObject:object row:row column:col];
            
            fooCol++;
        }
        
        fooRow ++;
        fooCol = 0;
    }
    
    
    
    [_contents release];
    _contents = nil;
    
    _contents = [[NSMutableArray alloc]init];
    _rows = result.rows;
    _columns = result.columns;
    
    for (int col=0; col<_columns; col++)
    {        
        NSMutableArray* column = [[NSMutableArray alloc]init];
        
        for (int row=0; row<_rows; row++)
        {            
            [column addObject:[result getObjectWithoutRemovingFromRow:row column:col]];            
        }
        
        [_contents addObject:column];   
        [column release];
    }
    
    [result release];
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
