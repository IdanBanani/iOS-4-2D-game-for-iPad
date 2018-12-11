//
//  MainMenuScene.h
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainMenuLayer.h"
#import "audioVisualizationLayer.h"

@interface MainMenuScene : CCScene 
{
    MainMenuLayer *mainMenuLayer;
    CCLayer *particleLayer;
    CCLayer *audioLayer;
}


@end
