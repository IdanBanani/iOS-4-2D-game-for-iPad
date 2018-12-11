//
//  GameScene.m
//  

#import "GameScene.h"
#import "cocos2d.h"
@implementation GameScene

-(id) init 
{    
    self =[super init];
    if (self != nil)
    {
        BackgroundLayer *bg = [BackgroundLayer node];
        [self addChild:bg z:0 tag:0];
        
        AnimalsLayer *animals = [AnimalsLayer node];
        [self addChild:animals z:2 tag:1];
    }
    return self;
}
@end
