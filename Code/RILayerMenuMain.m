//
//  RIMainMenu.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RILayerGamePlay.h"
#import "RILayerMenuChapterSelect.h"
#import "RILayerMenuMain.h"

//TODO need to set z-order of this scene.
@implementation RILayerMenuMain

+(RILayerMenuMain*)layer
{
    return [[[self alloc]init]autorelease];
}

-(id)init
{
    if(self = [super init])
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;  
        
        // Calculate Large Font Size
        int fontSize =  [NSLocalizedStringFromTable(RIKEY_FONT_SCALE_LARGE, RIKEY_FONTS, nil) intValue];
        NSAssert(fontSize>0, @"Main menu font size not specified");
        
        int largeFont = screenSize.height / fontSize; 
        
        NSString* fontName = NSLocalizedStringFromTable(RIKEY_MAIN_MENU_FONT, RIKEY_FONTS, nil);
        NSAssert(fontName!=nil, @"Main menu font name not specified");
        
        // Set font settings
        [CCMenuItemFont setFontName:fontName];
        [CCMenuItemFont setFontSize:largeFont];
        
        NSString* playText = NSLocalizedStringFromTable(RIKEY_PLAY, RIKEY_MAIN_MENU, nil);
        NSAssert(playText!=nil, @"Main menu playText not specified");
        
        NSString* optionsText = NSLocalizedStringFromTable(RIKEY_OPTIONS, RIKEY_MAIN_MENU, nil);
        NSAssert(optionsText!=nil, @"Main menu optionsText not specified");
        
        // Create font based items ready for CCMenu
        CCMenuItemFont *play = [CCMenuItemFont itemFromString:playText target:self selector:@selector(onPlay:)];
        CCMenuItemFont *options = [CCMenuItemFont itemFromString:optionsText target:self selector:@selector(onOptions:)];
        
        play.color = ccRED;
        options.color = ccRED;
        
        // Add font based items to CCMenu
        _menu = [[CCMenu menuWithItems:play, options, nil]retain];;
        
        // Align the menu 
        [_menu alignItemsVertically];
        
        // Add the menu to the scene
        self.visible = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveDisplayMenuNotification:) name:RINOTIFICATION_DISPLAY_MENU_MAIN object:nil];
        
        [pool drain];
    }
    
    return self;
}

-(void)dealloc
{
    [_menu release];
    [super dealloc];
}

-(void)onPlay:(id)sender
{
    self.visible = NO;
    [self removeChild:_menu cleanup:NO];
    //TODO when removing hack, uncomment the line below to select other levels.
    //[[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DISPLAY_CHAPTER_SELECT object:self];
    
    //TODO Before enabling chapters, need to publish chapter preview spritesheet and plist.
    
    //TODO Remove this hack when adding other level
    RILayerGamePlay* gamePlayLayer = [RILayerGamePlay sharedLayerGamePlay];
    if (gamePlayLayer.isDemoing)
    {
        [gamePlayLayer stopPlaying];
    }
    gamePlayLayer.visible = YES;
    [gamePlayLayer startPlayingFrom:0 isDemo:NO];
    //End of hack
}

-(void)onOptions:(id)sender
{
    self.visible = NO;
    [self removeChild:_menu cleanup:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:RINOTIFICATION_DISPLAY_OPTIONS object:self];
}

-(void)receiveDisplayMenuNotification:(NSNotification*)notification
{
    self.visible = YES;
    [self addChild:_menu];
}

@end
