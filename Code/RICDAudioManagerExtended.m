//
//  RICDAudioManagerExtended.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICDAudioManagerExtended.h"
#define BACKGROUND_MUSIC_CHANNEL kASC_Left

@implementation CDAudioManager(SoundFix)

- (id) init: (tAudioManagerMode) mode {
	if ((self = [super init])) {
		
		//Initialise the audio session
        float osVersion = [[UIDevice currentDevice].systemVersion floatValue];
        if (osVersion >=6.0)
        {
            [AVAudioSession sharedInstance];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interruption:) name:AVAudioSessionInterruptionNotification object:nil];
        }
        else
        {
            AVAudioSession* session = [AVAudioSession sharedInstance];
            session.delegate = self;
        }
        
		_mode = mode;
		backgroundMusicCompletionSelector = nil;
		_isObservingAppEvents = FALSE;
		_mute = NO;
		_resigned = NO;
		_interrupted = NO;
		enabled_ = YES;
		_audioSessionActive = NO;
		[self setMode:mode];
		soundEngine = [[CDSoundEngine alloc] init];
		
		//Set up audioSource channels
		audioSourceChannels = [[NSMutableArray alloc] init];
		CDLongAudioSource *leftChannel = [[CDLongAudioSource alloc] init];
		leftChannel.backgroundMusic = YES;
		CDLongAudioSource *rightChannel = [[CDLongAudioSource alloc] init];
		rightChannel.backgroundMusic = NO;
		[audioSourceChannels insertObject:leftChannel atIndex:kASC_Left];
		[audioSourceChannels insertObject:rightChannel atIndex:kASC_Right];
		[leftChannel release];
		[rightChannel release];
		//Used to support legacy APIs
		backgroundMusic = [self audioSourceForChannel:BACKGROUND_MUSIC_CHANNEL];
		backgroundMusic.delegate = self;
		
		//Add handler for bad al context messages, these are posted by the sound engine.
		[[NSNotificationCenter defaultCenter] addObserver:self	selector:@selector(badAlContextHandler) name:kCDN_BadAlContext object:nil];
        
	}
	return self;
}


- (void) interruption:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSUInteger interuptionType = (NSUInteger)[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey];
    
    if (interuptionType == AVAudioSessionInterruptionTypeBegan)
        [self beginInterruption];
#if __CC_PLATFORM_IOS >= 40000
    else if (interuptionType == AVAudioSessionInterruptionTypeEnded)
        [self endInterruptionWithFlags:(NSUInteger)[interuptionDict valueForKey:AVAudioSessionInterruptionOptionKey]];
#else
    else if (interuptionType == AVAudioSessionInterruptionTypeEnded)
        [self endInterruption];
#endif
}

@end
