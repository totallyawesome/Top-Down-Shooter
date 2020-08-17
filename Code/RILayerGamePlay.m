//
//  RILayerGamePlay.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIAudioManager.h"
#import "RIBackgroundTextureManager.h"
#import "RICommon.h"
#import "RILayerGamePlay.h"
#import "RILayerInput.h"
#import "RILayerMenuChapterSelect.h"

@implementation RILayerGamePlay
@synthesize spriteBatchNode = _spriteBatchNode;
@synthesize explosionsParticleBatchNode = _explosionParticleBatchNode;
@synthesize smokeParticleBatchNode = _smokeParticleBatchNode;
@synthesize isDemoing = _isDemoing;
@synthesize universe =_universe;

static RILayerGamePlay* instanceOfLayerGamePlay;
+(RILayerGamePlay*) sharedLayerGamePlay
{
	return instanceOfLayerGamePlay;
}

+(RILayerGamePlay*)layerWithGameData:(GDataXMLDocument*)gameData
{
    return [[[self alloc]initWithGameData:gameData]autorelease];
}

-(id)initWithGameData:(GDataXMLDocument*)gameData
{
    if (self = [super init])
    {
        instanceOfLayerGamePlay = self;
        _isPaused = NO;
        _isDemoing = NO;
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:RIPATH_TEXTURES_GAMESPRITESPLIST];
        _spriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:RIPATH_TEXTURES_GAMESPRITESTEXTURE];
        [self addChild:_spriteBatchNode z:RIZOrderGameObjectsSpriteBatchNode];
        
        //TODO look into adding the particle textures to the gamesprites png, and adding the particleBatchnodes to the spritebatchnode.
        CCParticleSystem* effect = [CCParticleSystemQuad particleWithFile:RIPATH_TEXTURES_EXPLOSIONPLIST];
        _explosionParticleBatchNode = [CCParticleBatchNode particleBatchNodeWithTexture:effect.texture capacity:500 useQuad:YES additiveBlending:YES];
        [self addChild:_explosionParticleBatchNode z:RIZorderParticlesExplosionsBatchNode];
        
        CCParticleSystem* smokeEffect = [CCParticleSystemQuad particleWithFile:RIPATH_TEXTURES_SMOKEPLIST];
        _smokeParticleBatchNode = [CCParticleBatchNode particleBatchNodeWithTexture:smokeEffect.texture capacity:500 useQuad:YES additiveBlending:YES];
        [self addChild:_smokeParticleBatchNode z:RIZorderParticlesExplosionsBatchNode];
        
        _dialogueManager = [[RIManagerDialogue alloc]init];
        
        GDataXMLElement* universeXML = [[gameData nodesForXPath:RIXPATH_UNIVERSE error:nil]objectAtIndex:0];
        
        _universe = [RIUniverse universeWithXML:universeXML];
        [self addChild:_universe z:RIZOrderUniverse];
        
        RILayerInput* inputLayer = [RILayerInput layerWithGameData:gameData];
        [self addChild:inputLayer z:RIZorderInputLayerControls];
        
        CCMenu* pauseButton = [self createPauseButton];
        [self addChild:pauseButton z:RIZOrderPauseButton tag:RITagButtonPause];
        pauseButton.visible = NO;

        [pool drain];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [_dialogueManager release];
    
    [super dealloc];
}

-(void)startPlayingFrom:(int)index isDemo:(BOOL)isDemo
{
    [_universe loadFromSpace:index];
    [self resumePlaying:isDemo];
}

//TODO: Subclass CCMenuItemSprite, so that the sprites used can be added to the spritebatchnode.
-(CCMenu*)createPauseButton
{
    CCSprite* pauseSprite = [CCSprite spriteWithSpriteFrameName:RISPRITE_PAUSE_BUTTON];
    
    CCSprite* pauseSpriteSelected = [CCSprite spriteWithSpriteFrameName:RISPRITE_PAUSE_BUTTON];
    
    CCMenuItem* pauseButton = [CCMenuItemSprite itemFromNormalSprite:pauseSprite selectedSprite:pauseSpriteSelected target:self selector:@selector(showPauseMenu:)];
    
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    pauseButton.position = ccp(winSize.width - (1.1)*pauseSprite.contentSize.width/2, winSize.height - (1.1)*pauseSprite.contentSize.height/2);
    
    CCMenu* pauseMenu = [CCMenu menuWithItems:pauseButton,nil];
    pauseMenu.position = CGPointZero;
    
    return pauseMenu;
}

-(void)showPauseMenu:(id)sender
{
    if (!_isPaused)
    {
        _isPaused = YES;
        [_universe pausePlaying];
        CCMenu* pauseMenuButton = (CCMenu*)[self getChildByTag:RITagButtonPause];
        pauseMenuButton.visible = NO;
        
        [[RILayerInput sharedLayerInput]hideCurrentController];
        [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DISPLAY_PAUSE_MENU object:self];
    }
}

-(void)stopPlaying
{
    [[RILayerInput sharedLayerInput]hideAllControls];
    [_universe stopPlaying:_isDemoing];
    
    if (self.isDemoing)
    {
        self.isDemoing = NO;
    }
    else
    {
        [self startDemo];
    }
}

-(void)startDemo
{
    self.isDemoing = YES;
    self.visible = YES;
    int demoIndex = [[RILayerMenuChapterSelect sharedLayer] demoSpaceIdForHighestUnlockedChapter];
    [self startPlayingFrom:demoIndex isDemo:YES];
}

-(void)resumePlaying:(BOOL)isDemo
{
    _isPaused = NO;
    [_universe resumePlaying];
    CCMenu* pauseMenuButton = (CCMenu*)[self getChildByTag:RITagButtonPause];
    if (!isDemo)
    {
        [[RILayerInput sharedLayerInput]showCurrentController];
        pauseMenuButton.visible = YES;
    }
    else
    {
        pauseMenuButton.visible = NO;
        self.isDemoing = YES;
    }

}

-(void)pausePlay
{
    if (self.isDemoing)
    {
        [_universe pausePlaying];
    }
    else
    {
        [self showPauseMenu:nil];
    }
}

-(void)becomeActive
{
    if (self.isDemoing)
    {
        [self resumePlaying:YES];
    }
}

@end
