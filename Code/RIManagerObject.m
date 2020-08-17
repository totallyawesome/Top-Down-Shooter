//
//  RIObjectManager.m
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import "CCSpriteBatchNodeExtended.h"
#import "RIGameObject.h"
#import "RILayerGamePlay.h"
#import "RILayerInput.h"
#import "RIManagerObject.h"

#import "RIRoleEnemy.h"
#import "RIRoleEnemyBoss.h"
#import "RIRoleEnemySidekick.h"
#import "RIRoleFriend.h"
#import "RIRoleFriendHero.h"
#import "RIRoleFriendSidekick.h"
#import "RIRoleEnemySidekick.h"
#import "RIRoleItem.h"
#import "RIRoleScenery.h"
#import "RIRoleUnassigned.h"

#import "RIStrategy.h"

@implementation RIManagerObject
@synthesize hero = _hero;
@synthesize friends = _friends;
@synthesize sidekicks = _sidekicks;
@synthesize boss = _boss;
@synthesize enemies = _enemies;
@synthesize henchmen = _henchmen;

static RIManagerObject* instanceOfObjectManager;
+(RIManagerObject*)sharedManager
{
    NSAssert(instanceOfObjectManager!=nil, @"ObjectManager instance not yet initialized!");
    return instanceOfObjectManager;
}

+(RIManagerObject*)manager
{
    return [[[self alloc]init]autorelease];
}

-(id)init
{
    if (self = [super init])
    {
        _activeObjects = [[NSMutableDictionary alloc]init];
        _inactiveObjects = [[NSMutableArray alloc]init];
        _wakingObjects = [[NSMutableArray alloc]init];
        _waves = [[NSMutableArray alloc]init];
        
        _nameToObject = [[NSMutableDictionary alloc]init];
        
        _hero = nil;
        _friends = [[NSMutableArray alloc]init];
        _sidekicks = [[NSMutableArray alloc]init];
        
        _boss = nil;
        _enemies = [[NSMutableArray alloc]init];
        _henchmen = [[NSMutableArray alloc]init];
        
        _items = [[NSMutableArray alloc]init];
        _scenery = [[NSMutableArray alloc]init];
        
        [_activeObjects setObject:_friends forKey:(id <NSCopying>)[RIRoleFriend class]];
        [_activeObjects setObject:_enemies forKey:(id <NSCopying>)[RIRoleEnemy class]];
        [_activeObjects setObject:_items forKey:(id <NSCopying>)[RIRoleItem class]];
        [_activeObjects setObject:_scenery forKey:(id <NSCopying>)[RIRoleScenery class]];
        
        instanceOfObjectManager = self;
    }
    
    return self;
}

-(void)dealloc
{
    [_activeObjects removeAllObjects];
    [_activeObjects release];
    _activeObjects = nil;
    
    [_inactiveObjects removeAllObjects];
    [_inactiveObjects release];
    _inactiveObjects = nil;
    
    [_wakingObjects removeAllObjects];
    [_wakingObjects release];
    _wakingObjects = nil;
    
    [_waves removeAllObjects];
    [_waves release];
    _waves = nil;
    
    [_nameToObject release];
    
    _hero = nil;
    [_friends release];
    [_sidekicks release];
    
    _boss = nil;
    [_enemies release];
    [_sidekicks release];
    
    [_items release];
    [_scenery release];
    
    [super dealloc];
}

-(BOOL)containsCharacterWithName:(NSString*)name
{
    BOOL containsCharacterWithName = NO;
    
    if ([_nameToObject objectForKey:name])
    {
        containsCharacterWithName = YES;
    }
    
    return containsCharacterWithName;
}

-(NSMutableArray*)unAssignedGameObjects:(int)count
{
    NSMutableArray* gameObjects = [[NSMutableArray alloc]init];
    
    while (gameObjects.count < count)
    {
        RIGameObject* gameObject = nil;
        if (_inactiveObjects.count >0)
        {
            gameObject = [_inactiveObjects objectAtIndex:0];
            [_inactiveObjects removeObjectAtIndex:0];
        }
        else
        {
            gameObject = [RIGameObject gameObject];
        }
        
        [gameObjects addObject:gameObject];
        [_wakingObjects addObject:gameObject];
    }
    
    return [gameObjects autorelease];
}

-(void)addObjectToActiveQueue:(RIGameObject*)gameObject
{
    Class factionId = gameObject.faction;
    if ([factionId isSubclassOfClass:[RIRoleUnassigned class]])
    {
        CCLOG(@"Error:Trying to add unassigned object. Ignoring.");
        [gameObject reset];
        return;
    }
    
    if ([factionId isSubclassOfClass:[RIRoleFriend class]])
    {
        [_friends addObject:gameObject];
        if ([factionId isSubclassOfClass:[RIRoleFriendSidekick class]])
        {
            [_sidekicks addObject:gameObject];
        }
        else if([factionId isSubclassOfClass:[RIRoleFriendHero class]])
        {
            _hero = gameObject;
        }
    }
    else if([factionId isSubclassOfClass:[RIRoleEnemy class]])
    {
        [_enemies addObject:gameObject];
        if ([factionId isSubclassOfClass:[RIRoleEnemySidekick class]])
        {
            [_henchmen addObject:gameObject];
        }
        else if([factionId isSubclassOfClass:[RIRoleEnemyBoss class]])
        {
            _boss = gameObject;
        }
    }
    else if([factionId isSubclassOfClass:[RIRoleItem class]])
    {
        [_items addObject:gameObject];
    }
    else if([factionId isSubclassOfClass:[RIRoleScenery class]])
    {
        [_scenery addObject:gameObject];
    }
    else
    {
        CCLOG(@"Unknown faction type. This should never happen");
    }
    
    if (gameObject.name)
    {
        [_nameToObject setObject:gameObject forKey:gameObject.name];
    }
    
    [gameObject activate];
}

-(void)moveWakingObjectToActiveQueue:(RIGameObject*)gameObject
{
    {
        [_wakingObjects removeObjectIdenticalTo:gameObject];
        [self addObjectToActiveQueue:gameObject];
    }
}

-(void)moveWakingObjectsToActiveQueue:(NSMutableArray*)objects
{
    for(RIGameObject* object in objects)
    {
        [self moveWakingObjectToActiveQueue:object];
    }
}

-(void)reset
{
    [[RILayerInput sharedLayerInput]hideAllControls];
    NSEnumerator* keyEnumeration = [_activeObjects keyEnumerator];
    id key;
    while (key = [keyEnumeration nextObject])
    {
        NSMutableArray* array = [_activeObjects objectForKey:key];
        for (RIGameObject* object in array)
        {
            [object reset];
            [_inactiveObjects addObject:object];
        }
        
        [array removeAllObjects];
    }
    
    for (RIGameObject* object in _wakingObjects)
    {
        [object reset];
        [_inactiveObjects addObject:object];
    }
    
    _hero = nil;
    [_friends removeAllObjects]; //should be empty by now. Likewise for other arrays too.
    [_sidekicks removeAllObjects];
    
    _boss = nil;
    [_enemies removeAllObjects];
    [_sidekicks removeAllObjects];
    
    [_items removeAllObjects];
    [_scenery removeAllObjects];
    
    [_wakingObjects removeAllObjects];
    
    [_nameToObject removeAllObjects];
    
}

-(void)addWaveToQueue:(RIWave*)wave
{
    [_waves addObject:wave];
}

-(void)createNextWave
{
    for (RIWave* wave in _waves)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc]init];
        
        NSMutableArray* objects = [self unAssignedGameObjects:wave.numberOfObjects];
        
        //Arrange them in formation & strategy described by wave
        [wave organizeObjects:objects];
        
        [self moveWakingObjectsToActiveQueue:objects];
        
        [pool drain];
    }
    
    [_waves removeAllObjects];
}

-(void)checkCollisions
{
    for (RIGameObject* enemy in _enemies)
    {
        if (enemy.plan.isCollidable)
        {
            //Check if enemies collides with friends
            for (RIGameObject* friend in _friends)
            {
                if (friend.plan.isCollidable)
                {
                    if ([self isCollisionBetweenSpriteA:friend spriteB:enemy pixelPerfect:YES])
                    {
                        //TODO must decide how to handle collisions.
                        [friend.plan.hits addObject:[NSNumber numberWithInt:enemy.plan.strength]];
                        [enemy.plan.hits addObject:[NSNumber numberWithInt:friend.plan.strength]];
                    }
                }
            }
        }
    }
    
    for (RIGameObject* item in _items)
    {
        for(RIGameObject* friend in _friends)
        {
            if ([self isCollisionBetweenSpriteA:friend spriteB:item pixelPerfect:YES])
            {
                
            }
        }
        //Check if items collides with friends
        
    }
}

-(void)updateActiveObjects:(ccTime)delta
{
    NSEnumerator* keyEnumerator = [_activeObjects keyEnumerator];
    id key;
    while (key = [keyEnumerator nextObject])
    {
        NSMutableArray* activeObjectGroup = [_activeObjects objectForKey:key];
        [self updateObjectsInGroup:activeObjectGroup time:delta];
    }
}

-(void)updateObjectsInGroup:(NSMutableArray*)activeGameObjectsGroup time:(ccTime)delta
{
    NSMutableArray* objectsWhichHaveCompletedPlan = [[NSMutableArray alloc]init];
    for (RIGameObject* object in activeGameObjectsGroup)
    {
        BOOL complete = [object executePlan:delta];
        if (complete)
        {
            [objectsWhichHaveCompletedPlan addObject:object];
        }
    }
    
    for (RIGameObject* object in objectsWhichHaveCompletedPlan)
    {
        if (object.name)
        {
            [_nameToObject removeObjectForKey:object.name];
        }

        [activeGameObjectsGroup removeObjectIdenticalTo:object];
        if ([object.faction isSubclassOfClass:[RIRoleFriend class]])
        {
            if ([object.faction isSubclassOfClass:[RIRoleFriendSidekick class]])
            {
                [_sidekicks removeObjectIdenticalTo:object];
            }
            else if([object.faction isSubclassOfClass:[RIRoleFriendHero class]])
            {
                _hero = nil;
            }
        }
        else if([object.faction isSubclassOfClass:[RIRoleEnemy class]])
        {
            if([object.faction isSubclassOfClass:[RIRoleEnemySidekick class]])
            {
                [_henchmen removeObjectIdenticalTo:object];
            }
            else if([object.faction isSubclassOfClass:[RIRoleEnemyBoss class]])
            {
                _boss = nil;
            }
        }
        
        [object reset];
        [_inactiveObjects addObject:object];
    }
    
    [objectsWhichHaveCompletedPlan removeAllObjects];
    [objectsWhichHaveCompletedPlan release];
}

-(void)act:(ccTime)delta
{
    [[RILayerInput sharedLayerInput]updateCommandSet];
    [self checkCollisions];
    [self updateActiveObjects:delta];
    [self createNextWave];
}

-(BOOL) isCollisionBetweenSpriteA:(CCSprite*)spr1 spriteB:(CCSprite*)spr2 pixelPerfect:(BOOL)pp
{
    BOOL isCollision = NO;
    
    CGRect intersection = CGRectIntersection([spr1 boundingBox], [spr2 boundingBox]);
    
    // Look for simple bounding box collision
    if (!CGRectIsEmpty(intersection))
    {
        // If we're not checking for pixel perfect collisions, return true
        if (!pp) {return YES;}
        
        CGPoint spr1OldPosition = spr1.position;
        CGPoint spr2OldPosition = spr2.position;
        
        spr1.position = CGPointMake(spr1.position.x - intersection.origin.x, spr1.position.y - intersection.origin.y);
        spr2.position = CGPointMake(spr2.position.x - intersection.origin.x, spr2.position.y - intersection.origin.y);
        
        intersection = CGRectIntersection([spr1 boundingBox], [spr2 boundingBox]);
        
        // Offset
        CCSpriteBatchNode* _sbnMain = [RILayerGamePlay sharedLayerGamePlay].spriteBatchNode;
        
        //NOTE: We are assuming that the spritebatchnode is always at 0,0
        
        // Get intersection info
        unsigned int x = (intersection.origin.x)* CC_CONTENT_SCALE_FACTOR();
        unsigned int y = (intersection.origin.y)* CC_CONTENT_SCALE_FACTOR();
        unsigned int w = intersection.size.width* CC_CONTENT_SCALE_FACTOR();
        unsigned int h = intersection.size.height* CC_CONTENT_SCALE_FACTOR();
        unsigned int numPixels = w * h;// * CC_CONTENT_SCALE_FACTOR();
        
        
        // create render texture and make it visible for testing purposes
        int renderWidth = w+1;
        int renderHeight = h+1;
        
        if(renderWidth<16)
        {
            renderWidth = 16;
        }
        
        if(renderHeight < 16)
        {
            renderHeight = 16;
        }
        
        CCRenderTexture* _rt = [[CCRenderTexture alloc] initWithWidth:renderWidth height:renderHeight pixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        
        //rt is always going to be at 0,0 - can't change it.
        _rt.position = CGPointMake(0, 0);
        
        [[RILayerGamePlay sharedLayerGamePlay]addChild:_rt];
        _rt.visible = YES;
        
        //NSLog(@"\nintersection = (%u,%u,%u,%u), area = %u",x,y,w,h,numPixels);
        
        // Draw into the RenderTexture
        [_rt beginWithClear:0 g:0 b:0 a:0];
        
        // Render both sprites: first one in RED and second one in GREEN
        glColorMask(1, 0, 0, 1);
        [_sbnMain visitSprite:spr1];
        glColorMask(0, 1, 0, 1);
        [_sbnMain visitSprite:spr2];
        glColorMask(1, 1, 1, 1);
        
        // Get color values of intersection area
        ccColor4B *buffer = malloc( sizeof(ccColor4B) * numPixels );
        glReadPixels(x, y, w, h, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
        
        [_rt end];
        
        
        // Read buffer
        unsigned int step = 1;
        for(unsigned int i=0; i<numPixels; i+=step)
        {
            ccColor4B color = buffer[i];
            
            if (color.r > 0 && color.g > 0)
            {
                isCollision = YES;
                break;
            }
        }
        
        // Free buffer memory
        free(buffer);
        
        spr1.position = spr1OldPosition;
        spr2.position = spr2OldPosition;
        
        [[RILayerGamePlay sharedLayerGamePlay]removeChild:_rt cleanup:YES];
        [_rt release];
    }
    return isCollision;
}

@end
