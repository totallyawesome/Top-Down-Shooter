//
//  RIDoubleDimensionArray.h
//  ProjectX
//
//  Created by Rahul Iyer on 06/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIDoubleDimensionArray : NSObject
{
    NSMutableArray* _contents;
    int _rows;
    int _columns;
}

@property(nonatomic,readonly) int rows;
@property(nonatomic,readonly) int columns;
@property(nonatomic,retain) NSMutableArray* contents;

+(RIDoubleDimensionArray*) arrayWithRows:(int)rows Columns:(int)columns;
-(id)initWithRows:(int)rows Columns:(int)columns;

-(void)putObject:(id)object row:(int)row column:(int)column;
-(id)getObjectWithoutRemovingFromRow:(int) row column:(int)column;
-(void)removeObjectFromRow:(int)row column:(int)column;
-(void) rotateMatrixAntiClockWise;

+ (void)fillColumn:(int)column row:(int)row matrix:(RIDoubleDimensionArray *)matrix;
+ (void)unFillColumn:(int)column row:(int)row matrix:(RIDoubleDimensionArray *)matrix;

@end
