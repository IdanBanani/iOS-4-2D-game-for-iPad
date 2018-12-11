//
//  WorldsScene.m
//  choosing between worlds


#import "WorldsScene.h"
#import "GameManager.h"

@implementation WorldsScene

-(id)init 
{
    self = [super init];
    if (self != nil)
    {
        
        LevelBGLayer *bg = [LevelBGLayer alloc];
        [bg initwithBG:kWorldsScene];  
        [self addChild:bg z:0];
        
        CCLayer *worlds = [WorldsLayer node];
        [self addChild:worlds z:5];
        
    }
    
    return self;
}

@end
