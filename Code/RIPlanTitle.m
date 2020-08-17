//
//  RIPlanTitle.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIPlanTitle.h"
#import "RISceneGame.h"

@implementation RIPlanTitle

-(id)initWithTarget:(id)target dismisser:(NSString *)dismisser data:(NSMutableDictionary *)data
{
    if (self = [super initWithTarget:target dismisser:dismisser data:data])
    {
        NSString* font = NSLocalizedStringFromTable(RIKEY_TITLE_FONT, RIKEY_FONTS, nil);
        NSString* title = NSLocalizedStringFromTable(RIKEY_FLYING_MACHINES, RIKEY_MAIN_MENU, nil);
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        float width = winSize.width*0.85;
        
        _title = [CCLabelBMFont labelWithString:title fntFile:font width:width alignment:UITextAlignmentCenter];
        _title.position = CGPointMake(winSize.width/2, _title.contentSize.height);
        [[RISceneGame sharedSceneGame]addChild:_title z:RIZOrderGameTitle];
        
        _hoverComplete = NO;
        _hoverCounter = 0;
        _endHeight = [[CCDirector sharedDirector]winSize].height + _title.contentSize.height;
        _scrollRate = ((winSize.height/2)/60)*3;
    }
    
    return self;
}

-(void)dealloc
{
    if (_title)
    {
        [[RISceneGame sharedSceneGame]removeChild:_title cleanup:YES];
    }
    
    [super dealloc];
}

-(BOOL)execute:(ccTime)delta
{
    BOOL isComplete = NO;
    
    if (!_hoverComplete)
    {
        _hoverCounter += delta;
        if (_hoverCounter>2)
        {
            _hoverComplete = YES;
        }
    }
    else
    {
        _title.position = CGPointMake(_title.position.x, _title.position.y +_scrollRate);
        
        if (_title.position.y > _endHeight)
        {
            isComplete = YES;
        }
    }
    
    return isComplete;
}

@end
