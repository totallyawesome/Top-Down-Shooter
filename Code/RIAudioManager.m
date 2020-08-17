//
//  RIAudioManager.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIAudioManager.h"
#import "CCControlSlider.h"

@implementation RIAudioManager
@synthesize currentlyPlayingTrack = _currentlyPlayingTrack;
@synthesize musicVolume = _musicVolume;
@synthesize effectsVolume = _effectsVolume;
@synthesize wasMusicPlaying = _wasMusicPlaying;

static RIAudioManager* instanceOfAudioManager;
+(RIAudioManager*)sharedAudioManager
{
    if (instanceOfAudioManager)
    {
        return instanceOfAudioManager;
    }
    else
    {
        return nil;
    }
    
}

-(id)init
{
    if (self = [super init])
    {
        // Set up the audio manager
        instanceOfAudioManager = self;
        _isInitialized = NO;
        _wasMusicPlaying = NO;
        _soundEngine = nil;
        _isModifyingMusic = NO;
        _loadedSoundEffects = [[NSMutableSet alloc]init];
        _operationQueue = [[NSOperationQueue alloc]init];
        [self initAudio];
    }
    
    return self;
}

-(void)dealloc
{
    [_operationQueue release];
    
    if (instanceOfAudioManager)
    {
        [instanceOfAudioManager release];
        instanceOfAudioManager = nil;
    }
    
    [self unloadAllSoundEffects];
    [_loadedSoundEffects release];
    [super dealloc];
}

-(void)playSoundEffect:(NSString*)effect
{
    [_soundEngine playEffect:effect];
    [_loadedSoundEffects addObject:effect];
}

-(void)pauseAllSoundEffects
{
    [_soundEngine pauseAllEffects];
}

-(void)resumeAllSoundEffects
{
    [_soundEngine resumeAllEffects];
}

-(void)stopAllSoundEffects
{
    [_soundEngine stopAllEffects];
}

-(void)unloadAllSoundEffects
{
    NSEnumerator* objectEnumerator = [_loadedSoundEffects objectEnumerator];
    id key;
    while (key = [objectEnumerator nextObject])
    {
        [self unloadSoundEffect:key];
    }
    
    [_loadedSoundEffects removeAllObjects];
}

-(void)unloadSoundEffect:(NSString*)effect
{
    [_soundEngine unloadEffect:effect];
}

-(void)initAudio
{
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    [CDAudioManager initAsynchronously:kAMM_FxPlusMusicIfNoOtherAudio];
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised)
    {
        [NSThread sleepForTimeInterval:0.1];
    }
    
    CDAudioManager *audioManager = [CDAudioManager sharedManager];
    if (audioManager.soundEngine == nil ||
        audioManager.soundEngine.functioning == NO)
    {
        CCLOG(@"CocosDenshion failed to init, no audio will play.");
        _isInitialized = NO;
    }
    else
    {
        [audioManager setResignBehavior:kAMRBStopPlay autoHandle:YES];
        _soundEngine = [SimpleAudioEngine sharedEngine];
        [_soundEngine setBackgroundMusicVolume:0.5f];
        [_soundEngine setEffectsVolume:0.5f];
        _musicVolume = [_soundEngine backgroundMusicVolume];
        _effectsVolume = [_soundEngine effectsVolume];
        _isInitialized = YES;
    }
}

-(void)playMusicAsync:(NSString*)trackName
{
    NSInvocationOperation* asyncSetupOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(playMusic:) object:trackName];
    [_operationQueue addOperation:asyncSetupOperation];
    [asyncSetupOperation release];
}

-(void)playMusic:(NSString*)trackName
{
    if (![self.currentlyPlayingTrack isEqualToString:trackName])
    {
        self.currentlyPlayingTrack = trackName;
        [_soundEngine preloadBackgroundMusic:trackName];
        [_soundEngine playBackgroundMusic:trackName];
        if ([_soundEngine isOtherAudioPlaying])
        {
            self.wasMusicPlaying = YES;
        }
        else
        {
            self.wasMusicPlaying = [_soundEngine isBackgroundMusicPlaying];
        }
    }
}

-(void)stopMusic
{
    [_soundEngine stopBackgroundMusic];
    self.currentlyPlayingTrack = nil;
    self.wasMusicPlaying = NO;
}

-(void)pauseMusic
{
    if (self.wasMusicPlaying)
    {
        [_soundEngine pauseBackgroundMusic];
    }
}

-(void)resumeMusic
{
    if (self.wasMusicPlaying)
    {
        [_soundEngine resumeBackgroundMusic];
    }
}

-(void)musicVolumeChanged:(id)sender
{
    if ([sender isKindOfClass:[CCControlSlider class]])
    {
        CCControlSlider* slider = (CCControlSlider*) sender;
        _musicVolume = slider.value;
        [_soundEngine setBackgroundMusicVolume:_musicVolume];
    }
}

-(void)effectsVolumeChanged:(id)sender
{
    if ([sender isKindOfClass:[CCControlSlider class]])
    {
        CCControlSlider* slider = (CCControlSlider*) sender;
        _effectsVolume = slider.value;
        [_soundEngine setEffectsVolume:_effectsVolume];
    }
}

@end
