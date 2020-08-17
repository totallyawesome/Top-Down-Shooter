//
//  RILayerChapter.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RILayerChapter.h"
#import "RILayerMenuChapterSelect.h"

@implementation RILayerChapter
@synthesize menu = _menu;
@synthesize spaceId = _spaceId;
@synthesize demoSpaceIndex = _demoSpaceIndex;

+(RILayerChapter*)layerWithChapter:(GDataXMLElement*)chapterXML responder:(id)responder highestUnlockedChapter:(int)highestUnlockedChapter
{
    return [[[self alloc]initWithChapter:chapterXML responder:responder highestUnlockedChapter:highestUnlockedChapter]autorelease];
}

-(id)initWithChapter:(GDataXMLElement*)chapterXML responder:(id)responder highestUnlockedChapter:(int)highestUnlockedChapter
{
    if (self = [super init])
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        //TODO need to fix the _isUnlocked to get from unlock file.
        _name = [[[chapterXML attributeForName:RIATTRIBUTE_NAME]stringValue]copy];
        _spaceId = [[[chapterXML attributeForName:RIATTRIBUTE_SPACE_ID]stringValue]intValue];
        _previewSpriteName = [[[chapterXML attributeForName:RIATTRIBUTE_PREVIEW_IMAGE]stringValue]copy];
        _demoSpaceIndex = [[[chapterXML attributeForName:RIKEY_DEMO_SPACE_INDEX]stringValue]intValue];
        _responder = responder;
        _number = [_name intValue];

        //TODO depending on whether the chapter is locked or unlocked we need to unlcok or lock the chapter and not allow the user to start directly.
        //TODO need to add preview / lock images for chapter etc instead of just having text.
        if (_number <= highestUnlockedChapter)
        {
            _isUnlocked = YES;
        }
        else
        {
            _isUnlocked = NO;
        }
        
        [pool drain];
    }
    
    return self;
}

-(void)loadPreviewImage
{
    if ([_responder isKindOfClass:[RILayerMenuChapterSelect class]])
    {        
        CCSprite* previewImage = [CCSprite spriteWithSpriteFrameName:_previewSpriteName];
        CCSprite* previewImageSelected = [CCSprite spriteWithSpriteFrameName:_previewSpriteName];
        previewImageSelected.scale = 1.1;
        CCSprite* lockedSprite = [CCSprite spriteWithSpriteFrameName:RISPRITE_PREVIEW_IMAGE_LOCKED];

        
        // Calculate Large Font Size
        int fontSize =  [NSLocalizedStringFromTable(RIKEY_FONT_SCALE_LARGE, RIKEY_FONTS, nil) intValue];
        NSAssert(fontSize>0, @"Chapter select font size not specified");
        
        CGSize screenSize = [[CCDirector sharedDirector]winSize];
        int largeFont = screenSize.height / fontSize;
        
        NSString* fontName = NSLocalizedStringFromTable(RIKEY_CHAPTER_SELECT_FONT, RIKEY_FONTS, nil);
        NSAssert(fontName!=nil, @"Chapter select font name not specified");
        
        // Set font settings
        [CCMenuItemFont setFontName:fontName];
        [CCMenuItemFont setFontSize:largeFont];
        
        //TODO need to add level name to previewImage and previewSelectedImage
//        NSString* levelNameText = NSLocalizedStringFromTable(_name, RIKEY_LEVEL_NAMES, nil);
//        NSAssert(levelNameText!=nil, @"Chapter select levelNameText not specified");
        
//        CCMenuItemFont* levelMenuItem = [CCMenuItemFont itemFromString:levelNameText target:_responder selector:@selector(onSelectChapter:)];
//        levelMenuItem.tag = _spaceId;
        
        CCMenuItemSprite* levelMenuItem = [CCMenuItemSprite itemFromNormalSprite:previewImage selectedSprite:previewImageSelected disabledSprite:lockedSprite target:_responder selector:@selector(onSelectChapter:)];
        levelMenuItem.tag = _spaceId;
        levelMenuItem.isEnabled = _isUnlocked;
        
        self.menu = [CCMenu menuWithItems:levelMenuItem, nil];
        
        [self.menu alignItemsVertically];
        
        [self addChild:self.menu];        
    }
}

-(void)unloadPreviewImage
{
    if (self.menu)
    {
        [self removeChild:self.menu cleanup:NO];
        self.menu = nil;
    }
}

-(void)unlock
{
    _isUnlocked = YES;
}

@end
