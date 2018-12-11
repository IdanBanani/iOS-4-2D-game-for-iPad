//
//  SceneLost.mm
// 

#import "SceneLost.h"

@implementation SceneLost

-(id) init 
{    
    self =[super init];
    if (self != nil)
    {
        
        [self removeChildByTag:1 cleanup:YES];
        
        LoseLayer *level = [LoseLayer node];
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
        
        CCMenu* menu = [CCMenu menuWithItems:backToLevelMenuButton, repitLevelButton, nil];
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

-(void) returnToLevelsMenu 
{
    [[GameManager sharedGameManager] runSceneWithID:kLevelMenuScene andScore:-1]; 
}

@end
