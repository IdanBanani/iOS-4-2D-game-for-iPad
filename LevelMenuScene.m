//
//  LevelMenuScene.m
//  Here we will select between the levels

#import "LevelMenuScene.h"

@implementation LevelMenuScene

-(id) init
{

    self =[super init];
    if (self != nil) 
    {
        LevelBGLayer *bg = [LevelBGLayer node];
        [bg initwithBG:kLevelMenuScene];
        [self addChild:bg z:0];
    
        CCLayer *buttonsLayer = [LevelMenuLayer levelMenuLayer];    
        [self addChild:buttonsLayer z:5];
    }
    
    return self;
}

@end



