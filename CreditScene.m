//
//  CreditScene.m
//  

#import "CreditScene.h"
#import "GameManager.h"

@implementation CreditScene 
    
-(id) init
{
    self = [super init];
    if (self != nil)
    {
        
        LevelBGLayer *bg = [LevelBGLayer alloc];
        [bg initwithBG:kCreditsScene];
        [self addChild:bg z:0];
        
        CCLayer *credit = [CreditLayer node];
        [self addChild:credit z:5];
        
    }
    
    return self;
}


@end
