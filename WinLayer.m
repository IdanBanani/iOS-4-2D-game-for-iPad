//
//  WinLayer.m
//  

#import "WinLayer.h"

@implementation WinLayer
@synthesize score;

-(id) initWithScore:(int)score1 
{
    self = [super init];
    if (self != nil) 
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        score = score1; //update the score of the player
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You Win with Score of %i!",score] 
                                               fontName:@"Arial" fontSize:70.0];
        [label setColor:ccc3(120,0,150)];
        
        label.position = ccp(screenSize.width * 1.5, screenSize.height * 0.55);
        [self addChild:label z:3];
        
        CCMoveTo *movvingLable = [CCMoveTo actionWithDuration:2.424f position:ccp(screenSize.width * 0.45, screenSize.height * 0.55)];
        CCDelayTime *delay = [CCDelayTime actionWithDuration:0.576];
        CCSequence *sequnce = [CCSequence actions:delay, movvingLable, nil];
        
        CCMoveTo *movvingTurtle = [CCMoveTo actionWithDuration:3.0f position:ccp(screenSize.width * 0.2, screenSize.height/2)];
        
        CCSprite *winTurtle = [CCSprite spriteWithSpriteFrameName:@"winTurtle2.png"];
        [winTurtle setPosition:CGPointMake(screenSize.width * 1.5 , screenSize.height/2)];
        [winTurtle setScale:1.2];
        [self addChild:winTurtle z:2];
        CCLOG(@"### winTurtle initialized");

        
        [label runAction:sequnce];
        [winTurtle runAction:movvingTurtle];

    }
    return self;
}

@end
