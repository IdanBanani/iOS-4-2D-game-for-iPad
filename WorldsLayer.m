//
//  WorldsLayer.m
//  choosing between worlds

#import "WorldsLayer.h"

@implementation WorldsLayer

-(void) playScene1
{ 
    [[GameManager sharedGameManager] runSceneWithID:kLevelMenuScene andScore:-1];
}

-(void) playScene2 
{
    
}

-(void)returnToMainMenu1
{
	[[GameManager sharedGameManager] runSceneWithID:kMainMenuScene andScore:-1];
}

-(id) init 
{
	self = [super init];
	if (self != nil)
    {
		CGSize screenSize = [CCDirector sharedDirector].winSize; 
        
        CCMenuItemImage *playWorld1 = [CCMenuItemImage  itemFromNormalImage:@"world11.png" 
                                                              selectedImage:@"world11.png" 
                                                              disabledImage:nil 
                                                                     target:self 
                                                                   selector:@selector(playScene1)];
        [playWorld1 setTag:1];
        
        CCMenuItemImage *playWorld2 = [CCMenuItemImage  itemFromNormalImage:@"world2.png" 
                                                              selectedImage:@"world2.png" 
                                                              disabledImage:nil 
                                                                     target:self 
                                                                   selector:@selector(playScene2)];
        [playWorld2 setTag:2];
        
        CCMenu *worldsMenu = [CCMenu menuWithItems:playWorld1, playWorld2, nil];
		
		[worldsMenu alignItemsHorizontallyWithPadding:screenSize.width * 0.06f];
		[worldsMenu setPosition:ccp(screenSize.width * 0.5f, screenSize.height * 0.5f)];
		[self addChild:worldsMenu];
    }
    return self;
}

@end
