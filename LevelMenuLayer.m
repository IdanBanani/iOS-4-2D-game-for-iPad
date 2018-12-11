//
//  LevelMenuLayer.m
//  Here we will select between the levels 

#import "LevelMenuScene.h"
#import "MainMenuScene.h"

@implementation LevelMenuLayer

+(LevelMenuLayer*) levelMenuLayer
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    LevelMenuLayer* levelmenu = [LevelMenuLayer alloc];
    
    //define a MutableArray which contains all the level select buttons
    int max = 20;
    NSMutableArray* allItems = [NSMutableArray array];
    for (int i = 1; i <= max; ++i)
    {
        NSString* normalImage; 
        NSString* selectedImage;// shown when pressed
        
        if (i <= 4) // we have built only four levels
        {
            normalImage = [NSString stringWithFormat:@"levelImageG.png"];
            selectedImage = [NSString stringWithFormat:@"levelImageB.png"];
        }
        else  
        {
            normalImage = [NSString stringWithFormat:@"levelImageL.png"]; //show a lock image
            selectedImage = [NSString stringWithFormat:@"levelImageL.png"];
        }
        
        CCSprite* normalSprite = [CCSprite spriteWithFile:normalImage];
        CCSprite* selectedSprite = [CCSprite spriteWithFile:selectedImage];
        CCMenuItemSprite* item =[CCMenuItemSprite itemFromNormalSprite:normalSprite
                                                        selectedSprite:selectedSprite
                                                                target:levelmenu
                                                              selector:@selector(selectLevelFromButton:)];
        
        NSString* labelStr = [NSString stringWithFormat:@"%d", i]; //print numbers on the buttons
        
        //Shadow the labels
        CCLabelTTF *label = [CCLabelTTF labelWithString:labelStr fontName:@"Marker Felt" fontSize:70];
        label.position = ccpAdd(ccpMult(ccpFromSize(normalSprite.contentSize), 0.5), ccp(2,-2));
        label.color = ccBLACK;
        [item addChild:label];
        
        //inside text
        label = [CCLabelTTF labelWithString:labelStr fontName:@"Marker Felt" fontSize:70];
        label.position = ccpMult(ccpFromSize(normalSprite.contentSize), 0.5);
        label.color = ccWHITE;
        [item addChild:label];

        item.tag = i; //give a tag to each item in the array
        [allItems addObject:item];  //add the item to the array   
        
    }
    //create the menu of the levels buttons with a grid view
    LevelMenuLayer* menuGrid = [[levelmenu initWithArray:allItems 
                                               cols:5 
                                               rows:2 
                                           position:CGPointMake(screenSize.width*0.15f, screenSize.height*0.7f) 
                                            padding:CGPointMake(screenSize.width*0.17f,screenSize.height*0.22f)] autorelease]; 

    
    return menuGrid;
}

-(void) selectLevelFromButton:(id)sender
{
    
    [self selectLevel:[sender tag]];
}

-(void) selectLevel:(int)level
{
    if (level == 1)
    {
        [[GameManager sharedGameManager] runSceneWithID:kGameLevel1 andScore:-1];
    }
    else if (level == 2) 
    {
        [[GameManager sharedGameManager] runSceneWithID:kGameLevel2 andScore:-1]; 
    }
    else if (level == 3) 
    {
        [[GameManager sharedGameManager] runSceneWithID:kGameLevel3 andScore:-1]; 
    }
    else if (level == 4)
    {
        [[GameManager sharedGameManager] runSceneWithID:kGameLevel4 andScore:-1]; 
    }
}

@end
