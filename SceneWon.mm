//
//  SceneWon.mm
// 

#import "SceneWon.h"

@implementation SceneWon

-(id) initWithPoints:(int)points
{    
    self =[super init];
    if (self != nil)
    {
    
        [self removeChildByTag:1 cleanup:YES]; //remove the animal scene from the background
        WinLayer *level = [WinLayer alloc];
        [level initWithScore:points];
        [self addChild:level z:5];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        //creating the buttons
        CCLabelTTF *repitLevelLable = [CCLabelTTF labelWithString:@"Repeat Level" fontName:@"MarkerFelt-Wide" fontSize:45];
        repitLevelLable.color = ccBLACK;
        CCMenuItemLabel *repitLevelButton = [CCMenuItemLabel itemWithLabel:repitLevelLable 
                                                                    target:self selector:@selector(repeatLevel)];
        
        CCLabelTTF *backToLevelMenuLable = [CCLabelTTF labelWithString:@"Back to Level Menu" fontName:@"MarkerFelt-Wide" fontSize:45];
        backToLevelMenuLable.color = ccBLACK;
        CCMenuItemLabel *backToLevelMenuButton = [CCMenuItemLabel itemWithLabel:backToLevelMenuLable 
                                                                         target:self selector:@selector(returnToLevelsMenu)];
        
        CCLabelTTF *nextLevelLable = [CCLabelTTF labelWithString:@"Next Level" fontName:@"MarkerFelt-Wide" fontSize:45];
        nextLevelLable.color = ccBLACK;
        CCMenuItemLabel *nextLevelButton = [CCMenuItemLabel itemWithLabel:nextLevelLable 
                                                                   target:self selector:@selector(nextLevel)];
        
        
        CCMenu* menu;
        SceneTypes scene = [[GameManager sharedGameManager] lastScene]; //get the level the player recently plaied
        
        //because we have only 4 levels, if you finish the 4'th level you dont the "Next Level" button.
        if (scene == kGameLevel4) 
        {
             menu = [CCMenu menuWithItems:backToLevelMenuButton, repitLevelButton, nil];
        }
        else 
        {
             menu = [CCMenu menuWithItems:backToLevelMenuButton, repitLevelButton, nextLevelButton, nil];

        }

        menu.position = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.1);
        menu.tag = 100;
        [menu alignItemsHorizontallyWithPadding:50];
        [self addChild:menu z:10];
    }
    return self;
    
}

//what the buttons do..
-(void) repeatLevel 
{
    [[GameManager sharedGameManager] runSceneWithID:[[GameManager sharedGameManager] lastScene] andScore:-1]; 
}

-(void) nextLevel 
{
     SceneTypes scene = [[GameManager sharedGameManager] lastScene];
    
    switch (scene)
    {
        case kGameLevel1:
            [[GameManager sharedGameManager] runSceneWithID:kGameLevel2 andScore:-1];
            break;
        case kGameLevel2:
            [[GameManager sharedGameManager] runSceneWithID:kGameLevel3 andScore:-1];
            break;
        case kGameLevel3:
            [[GameManager sharedGameManager] runSceneWithID:kGameLevel4 andScore:-1];
            break;
        case kGameLevel4:
            break;
            
        default:
            break;
    }
}


-(void) returnToLevelsMenu 
{
    [[GameManager sharedGameManager] runSceneWithID:kLevelMenuScene andScore:-1]; 
}

@end
