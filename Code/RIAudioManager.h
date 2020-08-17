//
//  RIAudioManager.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RISimpleAudioEngineExtended.h"

@interface RIAudioManager : NSObject
{
    BOOL _isInitialized;
    BOOL _wasMusicPlaying;
    BOOL _isModifyingMusic;
    
    NSOperationQueue* _operationQueue;
    
    NSString* _currentlyPlayingTrack;
    SimpleAudioEngine* _soundEngine;
    NSMutableSet* _loadedSoundEffects;
    
    float _musicVolume;
    float _effectsVolume;
}

@property(nonatomic,copy)NSString* currentlyPlayingTrack;
@property(nonatomic,readonly)float musicVolume;
@property(nonatomic,readonly)float effectsVolume;
@property(atomic, assign)BOOL wasMusicPlaying;

+(RIAudioManager*)sharedAudioManager;
-(void)playMusicAsync:(NSString*)trackName;
-(void)playMusic:(NSString*)trackName;
-(void)stopMusic;
-(void)pauseMusic;
-(void)resumeMusic;

-(void)playSoundEffect:(NSString*)effect;
-(void)resumeAllSoundEffects;
-(void)pauseAllSoundEffects;
-(void)stopAllSoundEffects;

-(void)musicVolumeChanged:(id)sender;
-(void)effectsVolumeChanged:(id)sender;

@end
