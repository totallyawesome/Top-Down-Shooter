//
//  CCSpriteBatchNodeExtended.m
//  ProjectX
//
//  Created by Rahul Iyer on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSpriteBatchNodeExtended.h"

static 	SEL selUpdate = NULL;

@implementation CCSpriteBatchNode(drawSpritesPPCD)

//+(void) initialize
//{
//	if ( self == [CCSpriteBatchNode class] ) {
//		selUpdate = @selector(updateTransform);
//	}
//}

-(void) drawSprite:(CCSprite*)spr
{
	[super draw];
    
	// Optimization: Fast Dispatch
	if( textureAtlas_.totalQuads == 0 )
		return;	
    
	CCSprite *child;
	ccArray *array = descendants_->data;
    
	NSUInteger i = array->num;
	id *arr = array->arr;
    
	unsigned int index = 0;
    
	if (i > 0)
	{
		while (i-- > 0)
		{
			child = *arr++;
            
			// fast dispatch
			if (child == spr)
			{
				index = [child atlasIndex];
				child->updateMethod(child, selUpdate);
			}
		}
        
		// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
		// Needed states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
		// Unneeded states: -
        
		BOOL newBlend = blendFunc_.src != CC_BLEND_SRC || blendFunc_.dst != CC_BLEND_DST;
		if( newBlend )
			glBlendFunc( blendFunc_.src, blendFunc_.dst );
        
		[textureAtlas_ drawNumberOfQuads:1 fromIndex:index];
        
		if( newBlend )
			glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
	}
}

-(void) visitSprite:(CCSprite*)spr
{
	if (!visible_)
		return;
    
	glPushMatrix();
    
	if ( grid_ && grid_.active) {
		[grid_ beforeDraw];
		[self transformAncestors];
	}
    
	[self transform];
    
	[self drawSprite:spr];
    
	if ( grid_ && grid_.active)
		[grid_ afterDraw:self];
    
	glPopMatrix();
}

@end
