//
//  RIUniverse.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIAudioManager.h"
#import "GDataXMLNode.h"
#import "RILayerGamePlay.h"
#import "RILayerMenuChapterSelect.h"
#import "RIManagerDialogue.h"
#import "RIManagerObject.h"
#import "RISpace.h"
#import "RITransitionFromBlack.h"
#import "RITransitionToBlack.h"
#import "RIUniverse.h"

@implementation RIUniverse
@synthesize activeSpace = _activeSpace;

+(RIUniverse*)universeWithXML:(GDataXMLElement*)universeXML
{
    return [[[self alloc]initWithUniverseXML:universeXML]autorelease];
}

-(id)initWithUniverseXML:(GDataXMLElement*)universeXML
{
    if (self = [super init])
    {
        //TODO read all the spaces from GameData, create them, and add them in order to the _spaces array
        _spaces = [[NSMutableArray alloc]init];
        _activeSpace = nil;
        _activeSpaceIndex = -1;
        _currentSpaceEndYLimit = -1;
        _winSize = [[CCDirector sharedDirector]winSize];
        _viewLimit = 2*_winSize.height;
        _isPlayerAlive = YES;
        _isTransitioning = YES;
        _isPreTransitioning = YES;
        _isStarted = NO;
        _dialogueManager = [RIManagerDialogue sharedManager];
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        NSArray* dataArray = [universeXML nodesForXPath:RIXPATH_SPACE error:nil];
        NSMutableArray* sortedSpaceArray = [self sortXmlByIndexAttribute:dataArray];
        
        float offset = 0.0;
        for (GDataXMLElement* spaceXML in sortedSpaceArray)
        {
            NSString* spaceTypeString = [[spaceXML attributeForName:RIKEY_TYPE]stringValue];
            Class spaceType = NSClassFromString(spaceTypeString);
            
            RISpace* space = [spaceType spaceWithXML:spaceXML offSet:offset];
            [_spaces addObject:space];
            [self addChild:space z:RIZOrderSpace];
            offset+= space.totalHeight;
        }
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveDeadHeroNotification:) name:RINOTIFICATION_DEAD_HERO object:nil];
        
        _failureTransition = [[RITransitionToBlack alloc]init];
        _startTransition = [[RITransitionFromBlack alloc]init];
        
        [pool drain];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [_spaces removeAllObjects];
    [_spaces release];
    _spaces = nil;
    
    _activeSpace = nil;
    [_failureTransition release];
    
    [_startTransition release];
    
    [super dealloc];
}

-(NSMutableArray*)sortXmlByIndexAttribute:(NSArray*)dataArray
{
    return [RICommon sortXmlByIndexAttribute:dataArray];
}

-(void)loadFromSpace:(int)spaceIndex
{
    [self assignActiveSpace:spaceIndex];
    
    self.position = CGPointMake(self.position.x, 0 - _activeSpace.startY);
    [_activeSpace updateBackgroundsAsync:NO];
}

- (BOOL)updateBackgrounds
{
    BOOL isNotEnd = YES;
    
    float windowStart = 0 - self.position.y;
    float windowFinish = windowStart + _viewLimit;
    for (int currentSpaceIndex = _activeSpaceIndex; currentSpaceIndex<_spaces.count; currentSpaceIndex++)
    {
        RISpace* currentSpace = [_spaces objectAtIndex:currentSpaceIndex];
        
        if ((currentSpace.startY >= windowStart && currentSpace.startY <=windowFinish)
            || (currentSpace.startY <=windowStart && currentSpace.endY >=windowStart))
        {
            [currentSpace updateBackgroundsAsync:YES];
        }
        else
        {
            break;
        }
    }
    
    if (windowStart > _currentSpaceEndYLimit)
    {
        if (!_activeSpace.isDemo)
        {
            
            int nextSpaceIndex = _activeSpaceIndex + 1;
            if (!((RISpace*)[_spaces objectAtIndex:nextSpaceIndex]).isDemo)
            {
                [_activeSpace deactivate];
                [self assignActiveSpace:++_activeSpaceIndex];
            }
            else
            {
                isNotEnd = NO;
            }
        }
        else
        {
            _isPlayerAlive = NO;
        }
    }
    
    return isNotEnd;
}

- (void)scrollUniverse:(ccTime)delta
{
    self.position = CGPointMake(self.position.x, self.position.y - _activeSpace.scrollRate*(60)*delta);
}

- (void)assignActiveSpace:(int)spaceIndex
{
    _activeSpaceIndex = spaceIndex;
    _activeSpace = [_spaces objectAtIndex:_activeSpaceIndex];
    _activeSpace.isActiveSpace = YES;
    
    int nextSpaceIndex = _activeSpaceIndex + 1;
    if (nextSpaceIndex <= [_spaces count] - 1 && !((RISpace*)[_spaces objectAtIndex:nextSpaceIndex]).isDemo)
    {
        _currentSpaceEndYLimit = _activeSpace.endY;
    }
    else
    {
        _currentSpaceEndYLimit = _activeSpace.endY -_winSize.height;
    }
    [[RILayerMenuChapterSelect sharedLayer]unlockLevelForSpaceId:_activeSpace.spaceId];
}

-(void)resetUniverse
{
    _activeSpaceIndex = -1;
    _activeSpace = nil;
    _currentSpaceEndYLimit = -1;
    _isPlayerAlive = YES;
    _isStarted = NO;
    [_failureTransition reset];
    [_startTransition reset];
    
    
    if (_startTransition.parent == nil)
    {
        [self.parent addChild:_startTransition z:RIZOrderLayerStartTransition];
    }
    
    
    [self.parent removeChild:_failureTransition cleanup:NO];
    [_failureTransition reset];
    _isTransitioning = YES;
    _isPreTransitioning = YES;
    [_dialogueManager reset];
    
    for (int i=0; i<_spaces.count; i++)
    {
        RISpace* currentSpace = [_spaces objectAtIndex:i];
        [currentSpace deactivate];
    }
}

-(void)resumePlaying
{
    [self schedule:@selector(play:) interval:(1/60)];
    [[RIAudioManager sharedAudioManager]resumeMusic];
    [[RIAudioManager sharedAudioManager]resumeAllSoundEffects];
}

-(void)play:(ccTime)delta
{
    if (!_isStarted)
    {
        _isStarted = [_startTransition transition:delta];
        if (_isStarted)
        {
            [self.parent removeChild:_startTransition cleanup:NO];
        }
    }
    else if (_isPlayerAlive)
    {
        if([self updateBackgrounds])
        {
            [self scrollUniverse:delta];
            [_activeSpace act:delta];
            [[RIManagerObject sharedManager]act:delta];
            [_dialogueManager manageDialogue:delta];
        }
        else
        {
            //We've finished the last level, and must transition back to the menu
            if (_isPreTransitioning)
            {
                [self.parent addChild:_failureTransition z:RIZOrderLayerFailureTransition];
                _isPreTransitioning = NO;
            }
            else if (_isTransitioning)
            {
                if([_failureTransition transition:delta])
                {
                    _isTransitioning = NO;
                }
            }
            else
            {
                //Reload level
                [[RILayerGamePlay sharedLayerGamePlay]stopPlaying];
            }
        }
    }
    else
    {
        int currentSpaceIndex = _activeSpaceIndex;
        //Death transitions
        if (_isPreTransitioning)
        {
            [self.parent addChild:_failureTransition z:RIZOrderLayerFailureTransition];
            _isPreTransitioning = NO;
        }
        else if (_isTransitioning)
        {
            if([_failureTransition transition:delta])
            {
                _isTransitioning = NO;
            }
        }
        else
        {
            //Reload level
            [self stopUniverseAndResetManager];
            [self loadFromSpace:currentSpaceIndex];
            [self resumePlaying];
        }
    }
}

-(void)receiveDeadHeroNotification:(NSNotification*)notification
{
    _isPlayerAlive = NO;
}

-(void)pausePlaying
{
    [self unscheduleAllSelectors];
    [[RIAudioManager sharedAudioManager]pauseMusic];
    [[RIAudioManager sharedAudioManager]pauseAllSoundEffects];
}

-(void)stopPlaying:(BOOL)isDemo
{
    [self stopUniverseAndResetManager];
    [[RIAudioManager sharedAudioManager]stopMusic];
    [[RIAudioManager sharedAudioManager]stopAllSoundEffects];
    
    if (!isDemo)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DISPLAY_MENU_MAIN object:nil];
    }
}

-(void)stopUniverseAndResetManager
{
    [self unscheduleAllSelectors];
    [self resetUniverse];
    [[RIManagerObject sharedManager]reset];
}

@end
