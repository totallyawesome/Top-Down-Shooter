//
//  RIStrategyFilledInvertedPyramid.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIGameObject.h"
#import "RIManagerObject.h"
#import "RIPlanEnemy.h"
#import "RIStrategyFilledInvertedPyramid.h"

@implementation RIStrategyFilledInvertedPyramid

+(void)arrange:(NSMutableArray *)gameObjects withDismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    BOOL towardsPlayer = [[data objectForKey:RIKEY_TOWARDS_PLAYER]boolValue];
    BOOL inlineWithPlayer = [[data objectForKey:RIKEY_INLINE_WITH_PLAYER]boolValue];

    
    //Each row has number of planes equal to its order. i.e. 1st row has one. Second row has two.
    int totalNumberOfPlanes = gameObjects.count;
    int numberOfPlanesInLastRow = 0;
    int numberOfPlanesInFormation = 0;;
    while ((numberOfPlanesInFormation = numberOfPlanesInLastRow*(numberOfPlanesInLastRow+1)/2)<totalNumberOfPlanes)
    {
        numberOfPlanesInLastRow++;
    }
    
    if (numberOfPlanesInLastRow > totalNumberOfPlanes)
    {
        numberOfPlanesInLastRow = totalNumberOfPlanes;
    }
    
    int sampleGameObjectHeight = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.height;
    int sampleGameObjectWidth = ((RIGameObject*)[gameObjects objectAtIndex:0]).contentSize.width;
    
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    RIGameObject* hero = [[RIManagerObject sharedManager]hero];

    int startX,finishX;
    if (inlineWithPlayer)
    {
        startX = MAX(sampleGameObjectWidth/2 ,hero.position.x - (numberOfPlanesInLastRow * sampleGameObjectWidth)/2);
    }
    else
    {
        startX = MAX( sampleGameObjectWidth/2,arc4random() % (int)(winSize.width - numberOfPlanesInLastRow*sampleGameObjectWidth*1.1));
    }
    
    if (towardsPlayer)
    {
        finishX = MAX(sampleGameObjectWidth/2 ,hero.position.x - (numberOfPlanesInLastRow * sampleGameObjectWidth)/2);
    }
    else
    {
        finishX = MAX( sampleGameObjectWidth/2,arc4random() % (int)(winSize.width - numberOfPlanesInLastRow*sampleGameObjectWidth*1.1));
    }

    
    int startY = winSize.height + sampleGameObjectHeight* numberOfPlanesInLastRow *1.1;
    
    CGPoint begin = CGPointMake(startX, startY);
    int diff = finishX - startX;
    
    int xOffSet = 0;
    int yOffset = 0;
    int columnCounter = 0;
    int rowCounter = numberOfPlanesInLastRow;
    int yctr = 0;
    int xctr = 0;
    int rowOffset = 0;
    for(RIGameObject* object in gameObjects)
    {
        CGPoint start = CGPointMake(begin.x + xOffSet, begin.y - yOffset);
        CGPoint cp1 = CGPointMake(begin.x + xOffSet + (diff)*0.33 , begin.y*0.66 - yOffset);
        CGPoint cp2 = CGPointMake(begin.x + xOffSet + (diff)*0.66, begin.y*0.33 - yOffset);
        CGPoint end = CGPointMake(finishX + xOffSet, - object.contentSize.height - yOffset);
        
        [data setObject:[NSValue valueWithCGPoint:start] forKey:RIKEY_START];
        [data setObject:[NSValue valueWithCGPoint:cp1] forKey:RIKEY_CP1];
        [data setObject:[NSValue valueWithCGPoint:cp2] forKey:RIKEY_CP2];
        [data setObject:[NSValue valueWithCGPoint:end] forKey:RIKEY_END_POINT];
        
        RIPlanEnemy* plan = [[RIPlanEnemy alloc]initWithTarget:object dismisser:dismisser data:data];
        object.plan = plan;
        [plan release];
        
        columnCounter++;
        if (columnCounter == rowCounter)
        {
            columnCounter = 0;
            rowCounter --;
            yctr++;
            xctr = numberOfPlanesInLastRow - rowCounter;
            rowOffset++;
        }
        else
        {
            xctr++;
        }
        
        xOffSet = xctr * sampleGameObjectWidth*1.1 - rowOffset*sampleGameObjectWidth/2;
        yOffset = yctr * sampleGameObjectHeight*1.1;
    }
}

@end
