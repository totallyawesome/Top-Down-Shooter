//
//  RIInputLayer.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "CCLayer.h"
#import "GDataXMLNode.h"
#import "RICommon.h"
#import "RIController.h"

@interface RILayerInput : CCLayer
{
    NSMutableDictionary* _controllers;
    RIController* _currentController;
    NSMutableArray* _currentCommandSet;
}

@property(nonatomic,readonly)NSMutableArray* currentCommandSet;

+(RILayerInput*)layerWithGameData:(GDataXMLDocument*)gameData;
-(id)initInputLayerWithGameData:(GDataXMLDocument*)gameData;
-(void)updateCommandSet;
+(RILayerInput*) sharedLayerInput;
-(void)showControl:(NSString*)identifier;
-(void)hideAllControls;
-(void)hideCurrentController;
-(void)showCurrentController;

@end
