//
//  RIDialogue.h
//  Top Down Shooter
//
//  Created by Rahul Iyer
//  Copyright (c) 2011 Rahul Iyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIDialogue : NSObject
{
    NSString* _dialogue; // This is the id used to identify dialogues in the strings file.
    NSString* _character;
    float _duration;
}

@property(nonatomic,readonly)float duration;
@property(nonatomic,copy,readonly)NSString* dialogue;
@property(nonatomic,copy,readonly)NSString* character;

-(id)initWithDialogue:(NSString*)dialogue character:(NSString*)character duration:(float)duration;

@end
