//
//  BGLayer.m
//  

#import "LevelBGLayer.h"
#import "MainMenuLayer.h"

@interface LevelBGLayer() 
-(void)displayBGMenu;
@end

@implementation LevelBGLayer

-(void) backToMenu:(CCMenuItemFont*)itemPassedIn 
{
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene andScore:-1];
}

//for randomizing the ball's speed
-(void) altertime:(ccTime)dt
{	
    id action1 = [redball2 getActionByTag:555];
    [action1 setSpeed: CCRANDOM_0_1() * 2];
}

//choose the background image & behaviour according to the scene 
-(id) initwithBG:(SceneTypes)type
{
    self = [super init];
    if (self != nil) 
    {
        self.isTouchEnabled=YES;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *bgImage;
        
        switch (type)
        {
                
            case kLevelMenuScene: //level select menu scene
            {
                bgImage = [CCSprite spriteWithFile:@"333.png"];
        
                redball2 = [CCSprite spriteWithFile:@"ball.png"];
                [redball2 setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.1f)];
                
                CCActionInterval *jump1 = [CCJumpBy actionWithDuration:4 position:ccp(400,0) height:300 jumps:2];
                CCActionInterval *jump2 = [jump1 reverse];
                CCActionInterval *rot1 = [CCRotateBy actionWithDuration:4 angle:360*2];
                CCActionInterval *rot2 = [rot1 reverse];
                id seq3_1 = [CCSequence actions:jump2, jump1, nil];
                id seq3_2 = [CCSequence actions: rot1, rot2, nil];
                id spawn = [CCSpawn actions:seq3_1, seq3_2, nil];
                id action = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:spawn] speed:1.0f];
                id action2 = [[action copy] autorelease];
                [action2 setTag:555];
                [redball2 runAction: action2];
                [self addChild:redball2 z:9]; 
                [self schedule:@selector(altertime:) interval:1.0f];
  
            }
                
            break;
            case kOptionsScene:
                bgImage = [CCSprite spriteWithFile:@"optionBG.png"];
                break;
            case kCreditsScene:
                bgImage = [CCSprite spriteWithFile:@"creditBG.png"];
                break;
            case kWorldsScene: //world selection scene
                bgImage = [CCSprite spriteWithFile:@"worldsBG.png"];
                break;
                
            default:
                break;
        }
        
        [bgImage setPosition: CGPointMake(screenSize.width/2, screenSize.height/2)];
        [self addChild:bgImage z:2 tag:7];

        
        CCLabelTTF *backButtonLabel = [CCLabelTTF labelWithString:@"Back to Main Menu" fontName:@"MarkerFelt-Wide" fontSize:40];
        backButtonLabel.color = ccBLUE;
        CCMenuItemLabel *backButton = [CCMenuItemLabel itemWithLabel:backButtonLabel target:self selector:@selector(backToMenu:)];
        
        CCMenu* menu = [CCMenu menuWithItems: backButton, nil];
        [menu setPosition: ccp(screenSize.width * 0.8f, screenSize.height * 0.1f)];
        [self addChild:menu z:10]; 

       
    }
    return self;
} 

@end
