//
//  RILayerMenuOptions.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIAudioManager.h"
#import "RICommon.h"
#import "RILayerMenuOptions.h"
#import "RILayerMenuPause.h"

@implementation RILayerMenuOptions

+(RILayerMenuOptions*)layer
{
    return [[[self alloc]init]autorelease];
}

-(id)init
{
    if (self = [super initWithColor:ccc4(110, 110, 110, 128)])
    {
        CGSize screenSize = [[CCDirector sharedDirector]winSize];
        
        // Calculate Large Font Size
        int fontSize =  32;
        NSString* font = NSLocalizedStringFromTable(RIKEY_MAIN_MENU_FONT, RIKEY_FONTS, nil);;
        NSString* musicVolumeText = NSLocalizedStringFromTable(RIKEY_MUSIC_VOLUME, RIKEY_OPTIONS_MENU, nil);;
        NSString* soundEffectsVolumeText = NSLocalizedStringFromTable(RIKEY_SOUNDFX_VOLUME, RIKEY_OPTIONS_MENU, nil);;
        
        _musicVolumeSlider = [[CCControlSlider sliderWithBackgroundFile:RIPATH_TEXTURES_SLIDERTRACKTEXTURE progressFile:RIPATH_TEXTURES_SLIDERTRACKTEXTURE thumbFile:RIPATH_TEXTURES_SLIDERTHUMBTEXTURE]retain];
        
        _musicVolumeSlider.anchorPoint = ccp(0.5f, 1.0f);
        _musicVolumeSlider.minimumValue = 0.0f; // Sets the min value of range
        _musicVolumeSlider.maximumValue = 1.0f; // Sets the max value of range
        _musicVolumeSlider.position = ccp(screenSize.width / 2.0f, screenSize.height / 2.0f - _musicVolumeSlider.contentSize.height/2);
        
        [_musicVolumeSlider addTarget:[RIAudioManager sharedAudioManager] action:@selector(musicVolumeChanged:) forControlEvents:CCControlEventValueChanged];
        _musicVolumeSlider.value = [RIAudioManager sharedAudioManager].musicVolume;
        
        _musicVolumeLabel = [CCLabelTTF labelWithString:musicVolumeText fontName:font fontSize:fontSize];
        _musicVolumeLabel.position = CGPointMake(screenSize.width/2, _musicVolumeSlider.position.y + _musicVolumeSlider.contentSize.height/2*1.1);
        [_musicVolumeLabel setColor:ccRED];

        [self addChild:_musicVolumeLabel];

        
        _effectsVolumeSlider = [[CCControlSlider sliderWithBackgroundFile:RIPATH_TEXTURES_SLIDERTRACKTEXTURE progressFile:RIPATH_TEXTURES_SLIDERTRACKTEXTURE thumbFile:RIPATH_TEXTURES_SLIDERTHUMBTEXTURE]retain];
        
        _effectsVolumeSlider.anchorPoint = ccp(0.5f, 1.0f);
        _effectsVolumeSlider.minimumValue = 0.0f; // Sets the min value of range
        _effectsVolumeSlider.maximumValue = 1.0f; // Sets the max value of range
        _effectsVolumeSlider.position = ccp(screenSize.width / 2.0f, _musicVolumeLabel.position.y + _musicVolumeLabel.contentSize.height*2);
        
        [_effectsVolumeSlider addTarget:[RIAudioManager sharedAudioManager] action:@selector(effectsVolumeChanged:) forControlEvents:CCControlEventValueChanged];
        _effectsVolumeSlider.value = [RIAudioManager sharedAudioManager].effectsVolume;
        
        _effectsVolumeLabel = [CCLabelTTF labelWithString:soundEffectsVolumeText fontName:font fontSize:fontSize];
        _effectsVolumeLabel.position = CGPointMake(screenSize.width/2, _effectsVolumeSlider.position.y + _effectsVolumeSlider.contentSize.height/2*1.1);
        [_effectsVolumeLabel setColor:ccRED];
        [self addChild:_effectsVolumeLabel];
        

        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveDisplayMenuNotification:) name:RINOTIFICATION_DISPLAY_OPTIONS object:nil];
        
        CCSprite* backSprite = [CCSprite spriteWithSpriteFrameName:RIPATH_TEXTURES_BACKTEXTURE];
        
        CCSprite* backSelectedSprite = [CCSprite spriteWithSpriteFrameName:RIPATH_TEXTURES_BACKSELECTEDTEXTURE];
        
        
        
        CCMenuItemSprite* _backButton = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSelectedSprite target:self selector:@selector(backButtonPressed:)];
        _backButton.position = ccp(backSprite.contentSize.width*0.6,backSprite.contentSize.height * 0.6);
        
        _backButtonMenu = [[CCMenu menuWithItems:_backButton,nil]retain];
        _backButtonMenu.position = CGPointZero;
        
        self.visible = NO;
        _isInGame = NO;
    }
    
    return self;
}

-(void)dealloc
{
    [_effectsVolumeSlider release];
    [_musicVolumeSlider release];
    [_backButtonMenu release];
    
    [super dealloc];
}

-(void)receiveDisplayMenuNotification:(NSNotification*)notification
{
    //Do whatever graphics etc when display the main menu.
    [self addChild:_musicVolumeSlider];
    [self addChild:_effectsVolumeSlider];
    [self addChild:_backButtonMenu];
    
    if ([notification.object isKindOfClass:[RILayerMenuPause class]])
    {
        _isInGame = YES;
    }
    
    self.visible = YES;
    if (_musicVolumeSlider.value != [RIAudioManager sharedAudioManager].musicVolume)
    {
        _musicVolumeSlider.value = [RIAudioManager sharedAudioManager].musicVolume;
    }
    
    if (_effectsVolumeSlider.value!= [RIAudioManager sharedAudioManager].effectsVolume)
    {
        _effectsVolumeSlider.value = [RIAudioManager sharedAudioManager].effectsVolume;
    }
    
}

-(void)backButtonPressed:(id)sender
{
    [self removeChild:_musicVolumeSlider cleanup:NO];
    [self removeChild:_effectsVolumeSlider cleanup:NO];
    [self removeChild:_backButtonMenu cleanup:NO];
    
    self.visible = NO;
    if (_isInGame)
    {
        _isInGame = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DISPLAY_PAUSE_MENU object:self];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DISPLAY_MENU_MAIN object:self];
    }
}

@end
