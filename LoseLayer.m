//
//  LoseLayer.m
// 

#import "LoseLayer.h"

@implementation LoseLayer

-(id) init 
{
    self = [super init];
    if (self != nil) 
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCScaleTo *scaleup = [CCScaleTo actionWithDuration:1.0 scale:1.0];
        CCScaleTo *scaledown = [CCScaleTo actionWithDuration:1.0 scale:0.6];
        CCSequence *sequnce = [CCSequence actions:scaledown, scaleup, nil];
        
        CCSprite *monster = [CCSprite spriteWithSpriteFrameName:@"lostSignFinal.png"];
        [monster setPosition:CGPointMake(screenSize.width/2 , screenSize.height/2)];
        [monster setScale:1.5];
        [self addChild:monster z:1];
        CCLOG(@"### monster initialized");
        
        [monster runAction:sequnce];
    
    }
    return self;
}

@end

