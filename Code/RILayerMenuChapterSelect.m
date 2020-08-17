//
//  RILayerChapterSelect.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "CCScrollLayer.h"
#import "RICommon.h"
#import "RILayerChapter.h"
#import "RILayerGamePlay.h"
#import "RILayerMenuChapterSelect.h"
#import "RISceneGame.h"

@implementation RILayerMenuChapterSelect

static RILayerMenuChapterSelect* instanceOfRILayerMenuChapterSelect;
+(RILayerMenuChapterSelect*)sharedLayer
{
    return instanceOfRILayerMenuChapterSelect;
}

+(RILayerMenuChapterSelect*)layerWithGameData:(GDataXMLDocument*)document
{
    return [[[self alloc]initWithGameData:document]autorelease];
}

-(id)initWithGameData:(GDataXMLDocument*)document
{
    if(self = [super init])
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        _layers = [[NSMutableArray alloc]init];
        _spaceChapterMapping = [[NSMutableDictionary alloc]init];
        _layerModifierLock = [[NSObject alloc]init];
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        _highestUnlockedChapter = [self highestUnlockedChapter];
        
        NSArray* chaptersArray = [document nodesForXPath:RIXPATH_CHAPTER error:nil];
        
        NSMutableArray* sortedChaptersArray = [self sortChaptersXMLArray:chaptersArray];
        
        for (int i=0; i<sortedChaptersArray.count; i++)
        {
            NSAutoreleasePool* forPool = [[NSAutoreleasePool alloc]init];
            
            GDataXMLElement* currentChapter = [sortedChaptersArray objectAtIndex:i];
            int spaceId = [[[currentChapter attributeForName:RIATTRIBUTE_SPACE_ID]stringValue]intValue];
            int chapter = [[[currentChapter attributeForName:RIATTRIBUTE_NAME]stringValue]intValue];
            [_spaceChapterMapping setObject:[NSNumber numberWithInt:chapter] forKey:[NSNumber numberWithInt:spaceId]];
            
            RILayerChapter* layer = [RILayerChapter layerWithChapter:[sortedChaptersArray objectAtIndex:i] responder:self highestUnlockedChapter:_highestUnlockedChapter];
            [_layers addObject:layer];
            
            [forPool drain];
        }
        
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:_layers
                                                            widthOffset:screenSize.width/2];
        [scroller selectPage:0];
        [self addChild:scroller];
        
        CCSprite* backSprite = [CCSprite spriteWithSpriteFrameName:RIPATH_TEXTURES_BACKTEXTURE];
        
        CCSprite* backSelectedSprite = [CCSprite spriteWithSpriteFrameName:RIPATH_TEXTURES_BACKSELECTEDTEXTURE];
        
        
        
        CCMenuItemSprite* _backButton = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSelectedSprite target:self selector:@selector(backButtonPressed:)];
        _backButton.position = ccp(backSprite.contentSize.width*0.6,backSprite.contentSize.height * 0.6);
        
        CCMenu* menu = [CCMenu menuWithItems:_backButton,nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];
        
        
        self.visible = NO;
        
        [scroller release];
        
        [pool drain];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveDisplayLayerChapterSelectNotificaton:) name:RINOTIFICATION_DISPLAY_CHAPTER_SELECT object:nil];
        
        instanceOfRILayerMenuChapterSelect = self;
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self unscheduleAllSelectors];
    [self unscheduleUpdate];
    
    [_layers release];
    [_spaceChapterMapping release];
    [_layerModifierLock release];
    
    [super dealloc];
}

-(int)highestUnlockedChapter
{
    NSNumber* highestUnlockedChapter = [[NSUserDefaults standardUserDefaults]
                                        objectForKey:RIKEY_HIGHEST_UNLOCKED_CHAPTER];
    if (!highestUnlockedChapter || [highestUnlockedChapter intValue] <=0 )
    {
        highestUnlockedChapter = [NSNumber numberWithInt:1];
        [[NSUserDefaults standardUserDefaults]setObject:highestUnlockedChapter forKey:RIKEY_HIGHEST_UNLOCKED_CHAPTER];
    }
    
    return [highestUnlockedChapter intValue];
}

-(NSMutableArray*)sortChaptersXMLArray:(NSArray*)dataArray
{
    NSMutableArray* sorted = [RICommon sortXmlArray:dataArray byAttribute:RIATTRIBUTE_SPACE_ID];
    return sorted;
}

- (void)loadPreviewImages
{
    @synchronized(_layerModifierLock)
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:RIPATH_TEXTURES_CHAPTERPREVIEWIMAGESPLIST];
        [[CCTextureCache sharedTextureCache]addImage:RIPATH_TEXTURES_CHAPTERPREVIEWIMAGESTEXTURE];
        
        for (RILayerChapter* chapter in _layers)
        {
            [chapter loadPreviewImage];
        }
    }
}

-(void)receiveDisplayLayerChapterSelectNotificaton:(NSNotification*)notification
{
    [self loadPreviewImages];
    
    [[RISceneGame sharedSceneGame]addChild:self z:RIZOrderLayerMenuChapterSelect];
    self.visible = YES;
}

-(void)unloadPreviewImages
{
    @synchronized(_layerModifierLock)
    {
        for (RILayerChapter* chapter in _layers)
        {
            [chapter unloadPreviewImage];
        }
        
        [[CCTextureCache sharedTextureCache]removeTextureForKey:RIPATH_TEXTURES_CHAPTERPREVIEWIMAGESTEXTURE];
        [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFramesFromFile:RIPATH_TEXTURES_CHAPTERPREVIEWIMAGESPLIST];
    }
}


-(void)onSelectChapter:(CCMenuItemFont*)sender
{
    RISceneGame* gameScene = [RISceneGame sharedSceneGame];
    [gameScene removeChild:self cleanup:NO];
    
    self.visible = NO;
    int level = sender.tag;
    
    [self unloadPreviewImages];
    
    RILayerGamePlay* gamePlayLayer = [RILayerGamePlay sharedLayerGamePlay];
    if (gamePlayLayer.isDemoing)
    {
        [gamePlayLayer stopPlaying];
    }
    gamePlayLayer.visible = YES;
    [gamePlayLayer startPlayingFrom:level isDemo:NO];
}

-(void)unlockLevelForSpaceId:(int)spaceId
{
    NSNumber* matchingChapterForSpaceId = [_spaceChapterMapping objectForKey:[NSNumber numberWithInt:spaceId]];
    
    if (matchingChapterForSpaceId)
    {
        int currentChapter = [matchingChapterForSpaceId intValue];
        if (currentChapter > _highestUnlockedChapter)
        {
            _highestUnlockedChapter = currentChapter;
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:_highestUnlockedChapter] forKey:RIKEY_HIGHEST_UNLOCKED_CHAPTER];
            
            RILayerChapter* chapterToUnlock = [_layers objectAtIndex:_highestUnlockedChapter-1];
            [chapterToUnlock unlock];
        }
    }
}

-(int)demoSpaceIdForHighestUnlockedChapter
{
    RILayerChapter* highestUnlockedChapter = [_layers objectAtIndex:_highestUnlockedChapter-1];
    return highestUnlockedChapter.demoSpaceIndex;
}

-(void)backButtonPressed:(id)sender
{
    self.visible = NO;
    RISceneGame* gameScene = [RISceneGame sharedSceneGame];
    [gameScene removeChild:self cleanup:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DISPLAY_MENU_MAIN object:self];
}

@end
