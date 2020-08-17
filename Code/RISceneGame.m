//
//  RISceneGame.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommon.h"
#import "RISceneGame.h"
#import "RILayerGamePlay.h"
#import "RILayerMenuPause.h"

@implementation RISceneGame

+(CCScene*) scene
{
	CCScene* scene = [CCScene node];
	
	RISceneGame* layer = [RISceneGame node];
	
	[scene addChild: layer];
	
	return scene;
}

static RISceneGame* instanceOfSceneGame;
+(RISceneGame*) sharedSceneGame
{
    NSAssert(instanceOfSceneGame != nil, @"RISceneGame instance not yet initialized!");
	return instanceOfSceneGame;
}

//Init, should just make sure that all the bare minimum is loaded and ready. 
//It should not start any kind of recurrent action. 
//It is just a starting point for user interaction.
-(id)init
{
    if (self = [super init])
    {
        [[CCDirector sharedDirector] setDisplayFPS:NO];
        _audioManager = [[RIAudioManager alloc]init];
        
        _backgroundTextureManager = [[RIBackgroundTextureManager backgroundTextureManager]retain];
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];

        NSString *filePath = [RIFileManager filePathWithinBundleForFile:RIPATH_GAME_DATA_XML];
        
        NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];

        RILayerGamePlay* foo = [RILayerGamePlay layerWithGameData:doc];
        [self addChild:foo];

        _layerMenuMain = [RILayerMenuMain layer];
        [self addChild:_layerMenuMain z:RIZOrderLayerMenuMain];
        
        _layerMenuOptions = [RILayerMenuOptions layer];
        [self addChild:_layerMenuOptions z:RIZOrderLayerMenuOptions];
        
        _layerMenuChapterSelect = [[RILayerMenuChapterSelect layerWithGameData:doc]retain];
        
        RILayerMenuPause* pauseMenu = [RILayerMenuPause layer];
        [self addChild:pauseMenu z:RIZOrderLayerMenuPause];
        
        _objectManager = [RIManagerObject manager];
        [self addChild:_objectManager];
        
        [doc release];
        [xmlData release];
        
        [pool drain];
        
        instanceOfSceneGame = self;
        
        //TODO add code to check if a game was interrupted but saved. If it was, then show the prompt instead of showing the main menu.
        [[RILayerGamePlay sharedLayerGamePlay]startDemo];
        [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DISPLAY_MENU_MAIN object:self];
        
    }
    
    return self;
}

-(void)dealloc
{
    [_audioManager release];
    _audioManager = nil;
    
    [_backgroundTextureManager release];
    _backgroundTextureManager = nil;
    
    [_layerMenuChapterSelect release];
    _layerMenuChapterSelect = nil;
    
    [super dealloc];
}

@end
