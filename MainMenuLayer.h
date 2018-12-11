//
//  MainMenuLayer.h
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameManager.h"

@interface MainMenuLayer : CCLayer 
{
    CCMenu *mainMenu;
    CCMenu *sceneSelectMenu;
    
    // These instance variables are defined in the CocosBuilder file
    // (example.ccb) and automatically assigned by CCBReader
    CCSprite* sprtBurst;
}
@end
