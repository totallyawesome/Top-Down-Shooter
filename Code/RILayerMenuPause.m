//
//  RILayerMenuPause.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICommon.h"
#import "RILayerGamePlay.h"
#import "RILayerMenuPause.h"

//TODO: Need to add some background color and artwork so text is more readable.
@implementation RILayerMenuPause

+(RILayerMenuPause*)layer
{
    return [[[self alloc]init]autorelease];
}

-(id)init
{
    if (self = [super initWithColor:ccc4(110, 110, 110, 128)])
    {        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // Calculate Large Font Size
        int fontSize =  [NSLocalizedStringFromTable(RIKEY_FONT_SCALE_LARGE, RIKEY_FONTS, nil) intValue];
        NSAssert(fontSize>0, @"Pause menu font size not specified");
        
        int largeFont = screenSize.height / fontSize;
        
        NSString* fontName = NSLocalizedStringFromTable(RIKEY_PAUSE_MENU_FONT, RIKEY_FONTS, nil);
        NSAssert(fontName!=nil, @"Pause menu font name not specified");
        
        // Set font settings
        [CCMenuItemFont setFontName:fontName];
        [CCMenuItemFont setFontSize:largeFont];
        
        NSString* resumeGameText = NSLocalizedStringFromTable(RIKEY_RESUME_GAME, RIKEY_PAUSE_MENU, nil);
        NSAssert(resumeGameText!=nil, @"Pause menu \"Resume game\" not specified");
        
        NSString* returnToMainMenuText = NSLocalizedStringFromTable(RIKEY_QUIT_GAME, RIKEY_PAUSE_MENU, nil);
        NSAssert(returnToMainMenuText!=nil, @"Pause menu \"Quit game\" not specified");
        
        NSString* audioSettingsText = NSLocalizedStringFromTable(RIKEY_AUDIO_SETTINGS, RIKEY_PAUSE_MENU, nil);
        NSAssert(audioSettingsText!=nil, @"Pause menu \"Audio settings\" not specified");
        
        // Create font based items ready for CCMenu
        CCMenuItemFont *quit = [CCMenuItemFont itemFromString:returnToMainMenuText target:self selector:@selector(onQuitToMain:)];
        quit.color = ccRED;
        
        CCMenuItemFont *audioSettings = [CCMenuItemFont itemFromString:audioSettingsText target:self selector:@selector(onAudioSettings:)];
        audioSettings.color = ccRED;
        
        CCMenuItemFont *resumeGame = [CCMenuItemFont itemFromString:resumeGameText target:self selector:@selector(onResumeGame:)];
        resumeGame.color = ccRED;
        
        // Add font based items to CCMenu
        _menu = [[CCMenu menuWithItems:resumeGame,audioSettings, quit, nil]retain];
        
        // Align the menu
        [_menu alignItemsVertically];
        
        // Add the menu to the scene
        self.visible = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveDisplayMenuNotification:) name:RINOTIFICATION_DISPLAY_PAUSE_MENU object:nil];
        
        [pool drain];
    }
    
    return self;
}

-(void)dealloc
{
    [_menu release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

-(void)receiveDisplayMenuNotification:(id)sender
{
    self.visible = YES;
    [self addChild:_menu];
}

-(void)onAudioSettings:(id)sender
{
    self.visible = NO;
    [self removeChild:_menu cleanup:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DISPLAY_OPTIONS object:self];
}

-(void)onQuitToMain:(id)sender
{
    self.visible = NO;
    [self removeChild:_menu cleanup:NO];
    [[RILayerGamePlay sharedLayerGamePlay]stopPlaying];
}

-(void)onResumeGame:(id)sender
{
    self.visible = NO;
    [self removeChild:_menu cleanup:NO];
    [[RILayerGamePlay sharedLayerGamePlay]resumePlaying:NO];

}

@end
