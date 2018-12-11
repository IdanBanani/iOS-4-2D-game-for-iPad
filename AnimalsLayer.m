//
//  AnimalsLayer.m
//  

#import "AnimalsLayer.h"

@implementation AnimalsLayer

-(id) init 
{
    self = [super init];
    if (self != nil) 
    {
        //load the images from the atlas
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animalScene_default.plist"];
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        //some general points for use
        float pos1 = screenSize.width * -0.2f;
        float pos2 = screenSize.width * 1.2f;
        float snailHeightL = screenSize.height * 0.05;
        float snailHeightH = screenSize.height * 0.1;
        float fishHeightL = screenSize.height * 0.4;
        float fishHeightH = screenSize.height * 0.8;
        float fish2pos = screenSize.width * 0.8;
        float fish2Hight = screenSize.height * 0.5;
        
        CCSprite *snail = [CCSprite spriteWithSpriteFrameName:@"gary-the-snail.png"];
        [snail setPosition:CGPointMake(pos1, snailHeightH)];
        [snail setFlipX:YES];
        [self addChild:snail z:1];
        CCLOG(@"### snail initialized");
        
        CCSprite *fish = [CCSprite spriteWithSpriteFrameName:@"fish.png"];
        [fish setPosition:CGPointMake(screenSize.width * 0.8f, fishHeightH)];
        [self addChild:fish z:1];
        CCLOG(@"### fish initialized");
        
        CCSprite *monsterFish = [CCSprite spriteWithSpriteFrameName:@"Monster_fish.png"];
        [monsterFish setPosition:CGPointMake(pos2, fishHeightH)];
        [self addChild:monsterFish z:1];
        CCLOG(@"### monsterFish initialized");
        
        CCSprite *seaHorse = [CCSprite spriteWithSpriteFrameName:@"seahorse.png"];
        [seaHorse setPosition:CGPointMake(pos1,screenSize.height * 0.5)];
        [seaHorse setScale:0.4f];
        [self addChild:seaHorse z:0];
        CCLOG(@"### seaHorse initialized");
        
        CCSprite *treasure = [CCSprite spriteWithSpriteFrameName:@"treasure.png"];
        [treasure setPosition:CGPointMake(screenSize.width * 0.92 , screenSize.height * 0.15)];
        [treasure setScale:0.5f];
        [treasure setFlipX:YES];
        [self addChild:treasure z:0];
        CCLOG(@"### treasure initialized");
        
        CCSprite *bubbles = [CCSprite spriteWithSpriteFrameName:@"bubbles2.png"];
        [bubbles setPosition:CGPointMake(treasure.position.x, treasure.position.y + 120)];
        [bubbles setScale:0.3f];
        [self addChild:bubbles z:0];
        CCLOG(@"### bubbles initialized");
        
        CCSprite *star = [CCSprite spriteWithSpriteFrameName:@"star.png"];
        [star setPosition:CGPointMake(screenSize.width * 0.1, screenSize.height * 0.08)];
        [star setScale:0.5f];
        [self addChild:star z:0];
        CCLOG(@"### star initialized");
        
        CCSprite *star2 = [CCSprite spriteWithSpriteFrameName:@"star.png"];
        [star2 setPosition:CGPointMake(screenSize.width * 0.6, screenSize.height * 0.05)];
        [star2 setScale:0.6f];
        [self addChild:star2 z:0];
        CCLOG(@"### star2 initialized");
        
        
        //move the monsterFish - one time
        CCSequence *fish2ActionMove = [CCSequence actions:
                                       [CCDelayTime actionWithDuration:40.0f],
                                       [CCMoveTo actionWithDuration:15.0 position:CGPointMake(fish2pos, fish2Hight)],
                                       [CCDelayTime actionWithDuration:0.3f],
                                       [CCMoveTo actionWithDuration:20.0f position:CGPointMake(pos2,fishHeightL/2)],
                                       nil];
        
        //scale the monsterFish - one time
        CCSequence *fish2ActionBig = [CCSequence actions: 
                                      [CCScaleTo actionWithDuration:0.0f scale:0.5],
                                      [CCDelayTime actionWithDuration:40.0f],
                                      [CCScaleTo actionWithDuration:15.0f scale:1.5f],
                                      [CCDelayTime actionWithDuration:21.0f], 
                                      nil];
        
        [monsterFish runAction:fish2ActionMove];
        [monsterFish runAction:fish2ActionBig];
        
        //move the snail - forever
        id snailAction = [CCRepeatForever actionWithAction:[CCSequence actions:
                                                            [CCScaleTo actionWithDuration:0.01f scale:0.4f],
                                                            [CCMoveTo actionWithDuration:0.01f position:CGPointMake(pos1, snailHeightH)],
                                                            [CCMoveTo actionWithDuration:20.0f position:CGPointMake(pos2, snailHeightH)],
                                                            [CCFlipX actionWithFlipX:NO],
                                                            
                                                            [CCScaleTo actionWithDuration:0.01f scale:0.7f],
                                                            [CCMoveTo actionWithDuration:0.01f position:CGPointMake(pos2, snailHeightL)],
                                                            [CCMoveTo actionWithDuration:14.0f position:CGPointMake(pos1, snailHeightL)],
                                                            [CCFlipX actionWithFlipX:YES],
                                                            
                                                            [CCScaleTo actionWithDuration:0.01f scale:0.6f],
                                                            [CCMoveTo actionWithDuration:16.0f position:CGPointMake(pos2, snailHeightL)],
                                                            [CCFlipX actionWithFlipX:NO],
                                                            
                                                            [CCScaleTo actionWithDuration:0.01f scale:0.4f],
                                                            [CCMoveTo actionWithDuration:0.01f position:CGPointMake(pos2, snailHeightH)],
                                                            [CCMoveTo actionWithDuration:20.0f position:CGPointMake(pos1, snailHeightH)],
                                                            [CCFlipX actionWithFlipX:YES],
                                                            
                                                            [CCScaleTo actionWithDuration:0.01f scale:0.5f],
                                                            [CCMoveTo actionWithDuration:18.0f position:CGPointMake(pos2, snailHeightH)],
                                                            [CCFlipX actionWithFlipX:NO],
                                                            
                                                            [CCScaleTo actionWithDuration:0.01f scale:0.6f],
                                                            [CCMoveTo actionWithDuration:0.01f position:CGPointMake(pos2, snailHeightL)],
                                                            [CCMoveTo actionWithDuration:16.0f position:CGPointMake(pos1, snailHeightL)],
                                                            [CCFlipX actionWithFlipX:YES],
                                                            
                                                            nil]];
        [snail runAction:snailAction];
        
        //move the little fish - forever
        id fishAction = [CCRepeatForever actionWithAction:[CCSequence actions:
                                                           [CCMoveTo actionWithDuration:8.0f position:CGPointMake(pos1, fishHeightH)],
                                                           [CCFlipX actionWithFlipX:YES],
                                                           
                                                           [CCDelayTime actionWithDuration:2.0f],
                                                           
                                                           [CCMoveTo actionWithDuration:0.01f position:CGPointMake(pos1, fishHeightL)],
                                                           [CCMoveTo actionWithDuration:4.0f position:CGPointMake(pos2, fishHeightL)],
                                                           [CCFlipX actionWithFlipX:NO],
                                                           
                                                           [CCDelayTime actionWithDuration:6.0f],
                                                           
                                                           [CCMoveTo actionWithDuration:6.0f position:CGPointMake(pos1, fishHeightH)],
                                                           [CCFlipX actionWithFlipX:YES],
                                                           
                                                           [CCDelayTime actionWithDuration:2.0f],
                                                           
                                                           [CCMoveTo actionWithDuration:3.0f position:CGPointMake(pos2, fishHeightH)],
                                                           [CCFlipX actionWithFlipX:NO],
                                                           [CCDelayTime actionWithDuration:3.0f],
                                                           
                                                           nil]];
        
        [fish runAction:fishAction];
        
        //move the seahorse - forever
        id seahorseAction = [CCRepeatForever actionWithAction:[CCSequence actions:
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 100, seaHorse.position.y + 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 200, seaHorse.position.y - 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 300, seaHorse.position.y + 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 400, seaHorse.position.y - 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 500, seaHorse.position.y + 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 600, seaHorse.position.y - 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 700, seaHorse.position.y + 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 800, seaHorse.position.y - 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 900, seaHorse.position.y + 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 1000, seaHorse.position.y - 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 1100, seaHorse.position.y + 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 1200, seaHorse.position.y - 100)],
                                                               [CCMoveTo actionWithDuration:2.0f position:CGPointMake(seaHorse.position.x + 1300, seaHorse.position.y + 100)],
                                                               [CCMoveTo actionWithDuration:0.0f position:seaHorse.position],
                                                               nil]];
        
        [seaHorse runAction:seahorseAction];
        
        //move the bubbles - forever
        id bubblesAction = [CCRepeatForever actionWithAction:[CCSequence actions:
                                                              [CCCallFunc actionWithTarget:self selector:@selector(music)], //call function to play the bubbles sound
                                                              [CCMoveTo actionWithDuration:6.0f position:CGPointMake(bubbles.position.x, screenSize.height * 1.2f)],
                                                              [CCMoveTo actionWithDuration:0.0f position:CGPointMake(treasure.position.x, treasure.position.y + 140)],
                                                              nil]];
        
        [bubbles runAction:bubblesAction];
        
        
        CCLOG(@"### animals initialized");
    }
    return self;    
}

//play the sound of the bubbles
-(void) music 
{
    PLAYSOUNDEFFECT(BUBBLE_SOUND);
}

@end
