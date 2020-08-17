//
//  RIManagerDialogue.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RILayerGamePlay.h"
#import "RIManagerDialogue.h"

@implementation RIManagerDialogue
@synthesize currentDialogue = _currentDialogue;

static RIManagerDialogue* instanceOfManagerDialogue;
+(RIManagerDialogue*)sharedManager
{
    return instanceOfManagerDialogue;
}

-(id)init
{
    if (self = [super init])
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        CGSize screenSize = [[CCDirector sharedDirector]winSize];
        
        
        CCSprite* _sampleCharacterSprite = [CCSprite spriteWithSpriteFrameName:RISPRITE_SAMPLE_CHARACTER_SPRITE];
        CCSprite* _pauseSprite = [CCSprite spriteWithSpriteFrameName:RISPRITE_PAUSE_BUTTON];
        
        _currentDialogue = nil;
        _timeSinceStartedSpeakingDialogue = 0.0f;
        _characterSpeakingLine = [CCSprite spriteWithSpriteFrameName:RISPRITE_ONE_PIX];
        [_characterSpeakingLine retain];

        [[RILayerGamePlay sharedLayerGamePlay].spriteBatchNode addChild:_characterSpeakingLine z:RIZOrderDialogue];
        
        //Calculations for dialogue width and position;
        _dialogueWidth = [[CCDirector sharedDirector]winSize].width;

        _dialogueWidth = _dialogueWidth - _sampleCharacterSprite.contentSize.width*1.01 - _pauseSprite.contentSize.width*1.01;
         _position = CGPointMake(_sampleCharacterSprite.contentSize.width*1.01, [[CCDirector sharedDirector]winSize].height);
        
        NSString* font = NSLocalizedStringFromTable(RIKEY_DIALOGUE_FONT, RIKEY_FONTS, nil);
        NSAssert(font!=nil, @"Dialogue font name not specified");
        _lineBeingSpoken = [CCLabelBMFont labelWithString:RIKEY_EMPTY_STRING fntFile:font width:_dialogueWidth alignment:UITextAlignmentLeft];
        _lineBeingSpoken.anchorPoint = CGPointMake(0,1);
        _lineBeingSpoken.position = _position;
        [_lineBeingSpoken retain];
        [[RILayerGamePlay sharedLayerGamePlay]addChild:_lineBeingSpoken z:RIZOrderDialogue];

        _backgroundForDialogue = [CCLayerColor layerWithColor:ccc4(110, 110, 110, 128) width:screenSize.width height:screenSize.height];
        _backgroundForDialogue.anchorPoint = CGPointMake(0,0);
        _backgroundForDialogue.position = CGPointMake(0,screenSize.height);
        [_backgroundForDialogue retain];
        [[RILayerGamePlay sharedLayerGamePlay]addChild:_backgroundForDialogue z:RIZorderBackgroundForDialogue];
        
        instanceOfManagerDialogue = self;
        
        [pool drain];
    }
    
    return self;
}

-(void)dealloc
{
    [_backgroundForDialogue release];
    [_characterSpeakingLine release];
    [_lineBeingSpoken release];
    
    [super dealloc];
}

-(void)reset
{
    [self clearDialogue];
}

-(void)speakDialogue:(RIDialogue*)dialogue
{
    if (!self.currentDialogue)
    {
        self.currentDialogue = dialogue;
        CGSize screenSize = [[CCDirector sharedDirector]winSize];
        
        NSString* bar = NSLocalizedStringFromTable(dialogue.dialogue, RIKEY_DIALOGUE_TABLE, "The line being spoken");
        
        [_characterSpeakingLine setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:dialogue.character]];
        _characterSpeakingLine.position = CGPointMake(_characterSpeakingLine.contentSize.width/2, screenSize.height - _characterSpeakingLine.contentSize.height/2);        
        
        [_lineBeingSpoken setString:bar];
        _backgroundForDialogue.position = CGPointMake(0,screenSize.height - _lineBeingSpoken.contentSize.height*1.1);
    }
}

-(void)manageDialogue:(ccTime)delta
{
    if (self.currentDialogue)
    {
        _timeSinceStartedSpeakingDialogue +=delta;
        if (_timeSinceStartedSpeakingDialogue >= self.currentDialogue.duration)
        {
            [self clearDialogue];
        }
    }
}

-(void)clearDialogue
{
    [_lineBeingSpoken setString:RIKEY_EMPTY_STRING];
    [_characterSpeakingLine setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:RISPRITE_ONE_PIX]];
    
    CGSize screenSize = [[CCDirector sharedDirector]winSize];
    _backgroundForDialogue.position = CGPointMake(0,screenSize.height);
    
    self.currentDialogue = nil;
    _timeSinceStartedSpeakingDialogue = 0.0f;
}

@end
