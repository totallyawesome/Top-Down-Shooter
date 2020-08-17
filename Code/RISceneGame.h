//
//  RISceneGame.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "cocos2d.h"
#import "RIAudioManager.h"
#import "RIBackgroundTextureManager.h"
#import "RILayerMenuChapterSelect.h"
#import "RILayerMenuMain.h"
#import "RILayerMenuOptions.h"
#import "RIManagerObject.h"

@interface RISceneGame : CCLayer
{
    RIBackgroundTextureManager* _backgroundTextureManager;
    
    RILayerMenuChapterSelect* _layerMenuChapterSelect;
    RILayerMenuMain* _layerMenuMain;
    RILayerMenuOptions* _layerMenuOptions;
    
    RIManagerObject* _objectManager;
    RIAudioManager* _audioManager;
}

+(CCScene*) scene;
+(RISceneGame*) sharedSceneGame;

@end
