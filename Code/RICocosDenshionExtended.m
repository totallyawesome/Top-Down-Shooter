//
//  RICocosDenshionExtended.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RICocosDenshionExtended.h"

@implementation CDSoundEngine(pauseFX)

- (void)pauseAllSounds
{
	for (int i=0; i < sourceTotal_; i++)
	{
		ALint state;
		alGetSourcei(_sources[i].sourceId, AL_SOURCE_STATE, &state);
		if(state == AL_PLAYING)
		{
			alSourcePause(_sources[i].sourceId);
		}
	}
	alGetError();
}

- (void)resumeAllSounds
{
	for (int i=0; i < sourceTotal_; i++)
	{
		ALint state;
		alGetSourcei(_sources[i].sourceId, AL_SOURCE_STATE, &state);
		if(state == AL_PAUSED)
		{
			alSourcePlay(_sources[i].sourceId);
		}
	}
	alGetError();
}

-(int)_getSourceIndexForSourceGroup:(int)sourceGroupId
{
	//Ensure source group id is valid to prevent memory corruption
	if (sourceGroupId < 0 || sourceGroupId >= _sourceGroupTotal) {
		CDLOG(@"Denshion::CDSoundEngine invalid source group id %i",sourceGroupId);
		return CD_NO_SOURCE;
	}
    
	int sourceIndex = -1;//Using -1 to indicate no source found
	BOOL complete = NO;
	ALint sourceState = 0;
	sourceGroup *thisSourceGroup = &_sourceGroups[sourceGroupId];
	thisSourceGroup->currentIndex = thisSourceGroup->startIndex;
	while (!complete) {
		//Iterate over sources looking for one that is not locked, first bit indicates if source is locked
		if ((thisSourceGroup->sourceStatuses[thisSourceGroup->currentIndex] & 1) == 0) {
			//This source is not locked
			sourceIndex = thisSourceGroup->sourceStatuses[thisSourceGroup->currentIndex] >> 1;//shift back to get the index
            alGetSourcei(_sources[sourceIndex].sourceId, AL_SOURCE_STATE, &sourceState);
            if (thisSourceGroup->nonInterruptible)
            {
                // Check if this source is playing, if so it can't be interrupted
                if (sourceState != AL_PLAYING && sourceState != AL_PAUSED)
                {
                    //Set start index so next search starts at the next position
                    thisSourceGroup->startIndex = thisSourceGroup->currentIndex + 1;
                    break;
                }
                else
                {
                    sourceIndex = -1; //The source index was no good because the source was playing
                }
            }
            else
            {
                if(sourceState != AL_PAUSED)
                {
                    // Set start index so next search starts at the next position
                    thisSourceGroup->startIndex = thisSourceGroup->currentIndex + 1;
                    break;
                }
            }
		}
		thisSourceGroup->currentIndex++;
		if (thisSourceGroup->currentIndex >= thisSourceGroup->totalSources) {
			//Reset to the beginning
			thisSourceGroup->currentIndex = 0;
		}
		if (thisSourceGroup->currentIndex == thisSourceGroup->startIndex) {
			//We have looped around and got back to the start
			complete = YES;
		}
	}
    
	//Reset start index to beginning if beyond bounds
	if (thisSourceGroup->startIndex >= thisSourceGroup->totalSources) {
		thisSourceGroup->startIndex = 0;
	}
	
	if (sourceIndex >= 0) {
		return sourceIndex;
	} else {
		return CD_NO_SOURCE;
	}
	
}


@end
