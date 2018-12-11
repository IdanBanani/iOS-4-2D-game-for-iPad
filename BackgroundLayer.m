//
//  BackgroundLayer.m
// 

#import "BackgroundLayer.h"

@implementation BackgroundLayer

-(void) backToMenu:(CCMenuItemFont*)itemPassedIn 
{
    [[GameManager sharedGameManager] runSceneWithID:kLevelMenuScene andScore:-1];
}


-(id) init 
{
    self = [super init];
    if (self != nil) 
    {
        self.isTouchEnabled = true;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // load the background image
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        CCSprite *background = [CCSprite spriteWithFile:@"underwater_bg.png"];
        background.anchorPoint = ccp(0,0);
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        
        [self addChild:background z:0];
        CCLOG(@"### background initialized");
        
        CCLabelTTF *backButtonLabel = [CCLabelTTF labelWithString:@"Exit" fontName:@"MarkerFelt-Wide" fontSize:40];
        backButtonLabel.color = ccWHITE;
        CCMenuItemLabel *backButton = [CCMenuItemLabel itemWithLabel:backButtonLabel target:self selector:@selector(backToMenu:)];
        
        CCMenu* menu = [CCMenu menuWithItems: backButton, nil];
        [menu setPosition: ccp(screenSize.width * 0.95f, screenSize.height * 0.97f)];
        [self addChild:menu z:10]; 
    }
    return self;
}

@end
