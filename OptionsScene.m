//
//  MenuScene.m
// 

#import "OptionsScene.h"

@implementation OptionsScene


-(id) init 
{
    self = [super init];
    if (self != nil) 
    {
        
        LevelBGLayer *bg = [LevelBGLayer alloc];
        [bg initwithBG:kOptionsScene];
        [self addChild:bg z:0];
        
        CCLayer *options = [OptionsLayer node];
        [self addChild:options z:5];
        
    }
    
    return self;
}

@end
