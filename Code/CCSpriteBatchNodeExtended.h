//
//  CCSpriteBatchNodeExtended.h
//  ProjectX
//
//  Created by Rahul Iyer on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCSpriteBatchNode(drawSpritesPPCD)

-(void) drawSprite:(CCSprite*)spr;
-(void) visitSprite:(CCSprite*)spr;

@end
