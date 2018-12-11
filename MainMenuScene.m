//
//  MainMenuScene.m
// 

#import "MainMenuScene.h"

//cocos builder//
#import "CCBReader.h" 

@implementation MainMenuScene

-(id) init
{
    self = [super init];
    if (self != nil)
    {
        mainMenuLayer = [MainMenuLayer node]; 
        [self addChild:mainMenuLayer z:2];
        
        particleLayer = (CCLayer*)[CCBReader nodeGraphFromFile:@"particleLayer.ccb"];
        [self addChild:particleLayer z:0];
        
        audioLayer = [AudioVisualizationLayer node];
        [self addChild:audioLayer z:30];
    }
    return self;
}

@end


