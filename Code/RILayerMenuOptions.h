//
//  RILayerMenuOptions.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "CCControlSlider.h"
#import "cocos2d.h"
#import "RICommon.h"

@interface RILayerMenuOptions : CCLayerColor
{
    CCLabelTTF* _musicVolumeLabel;
    CCLabelTTF* _effectsVolumeLabel;
    
    CCControlSlider* _musicVolumeSlider;
    CCControlSlider* _effectsVolumeSlider;
    
    CCMenu* _backButtonMenu;
    
    BOOL _isInGame;
}

+(RILayerMenuOptions*) layer;
@end
