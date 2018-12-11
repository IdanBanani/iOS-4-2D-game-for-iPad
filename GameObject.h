//
//  GameObject.h
//  

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "CommonProtocols.h"

@interface GameObject : CCSprite
{
    BOOL isActive;
    CGSize ScreenSize;
    GameObjectType gameObjectType;
}

@property (readwrite) BOOL isActive;
@property (readwrite) CGSize screenSize;
@property (readwrite) GameObjectType gameObjectType;

-(void)changeState:(CharacterStates)newState;

-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
                                andClassName:(NSString*)className;

@end
