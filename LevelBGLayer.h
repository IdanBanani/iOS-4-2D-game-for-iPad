//
//  LevelBGLayer.h
// 

#import "CCLayer.h"
#import "cocos2d.h"
#import "GameManager.h"

@interface LevelBGLayer : CCLayer 
{
    CCSprite* redball2; //bouncing ball
}

-(void) altertime:(ccTime)dt; //for randomizing the ball's speed
-(id)initwithBG:(SceneTypes)type; //choose the background image & behaviour according to the scene 

@end


