//
//  RIGameObject.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "RIGameObject.h"
#import "RILayerGamePlay.h"
#import "RIRoleUnassigned.h"

@implementation RIGameObject
@synthesize faction = _faction;
@synthesize plan = _plan;
@synthesize name = _name;

+(RIGameObject*)gameObject
{
    return [[[self alloc]initGameObject]autorelease];
}

-(id)initGameObject
{
    if(self = [super initWithSpriteFrameName:RISPRITE_ONE_PIX])
    {
        _faction = [RIRoleUnassigned class];
        _name = nil;
        //TODO update code so that diffferent kinds of objects or factions etc have different z-orders. Or make it so that it can be changed and reset at runtime.
        [[RILayerGamePlay sharedLayerGamePlay].spriteBatchNode addChild:self z:RIZOrderGameObjectsSpriteBatchNode];
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

//TODO: Do a check in all code for changes to a gameObject, and reset them here.
-(void)reset
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    self.position = CGPointMake(0,winSize.height*2);
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:RISPRITE_ONE_PIX]];
    self.plan = nil;
    self.flipX = NO;
    self.flipY = NO;
    _isActive = NO;
    self.visible = NO;
    self.scaleX = 1;
    self.scaleY = 1;
    self.scale = 1;
    self.rotation = 0;
    self.anchorPoint = ccp(0.5f,0.5f);
    _faction = [RIRoleUnassigned class];
    self.name = nil;
    [self removeAllChildrenWithCleanup:YES];
}

-(void)activate
{
    _isActive = YES;
    self.visible = YES;
}

-(BOOL)executePlan:(ccTime)delta
{
    return [self.plan execute:delta];
}

@end
