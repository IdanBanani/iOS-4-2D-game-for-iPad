//
//  MainMenuLayer.m
//  

#import "MainMenuLayer.h"

@interface MainMenuLayer() 
-(void)displayMainMenu;
-(void)displaySceneSelection;
@end

@implementation MainMenuLayer


-(void) showOptions
{
    [[GameManager sharedGameManager] runSceneWithID:kOptionsScene andScore:-1]; 
}

-(void) showCredit
{
    [[GameManager sharedGameManager] runSceneWithID:kCreditsScene andScore:-1]; 
}

-(void) showWorlds 
{
    [[GameManager sharedGameManager] runSceneWithID:kWorldsScene andScore:-1];
}

-(void) displayMainMenu 
{ 
    //create the main buttons and place them on screen
    
    CGSize screenSize = [CCDirector sharedDirector].winSize; 
    
    //Main menu should be initiallized,if so remove it from the layer 
     if (sceneSelectMenu != nil) 
     {    
         [sceneSelectMenu removeFromParentAndCleanup:YES];
    }
    
    // Main Menu
    CCMenuItemImage *playGameButton = [CCMenuItemImage 
                                       itemFromNormalImage:@"playW.png" 
                                       selectedImage:@"playB.png" 
                                       disabledImage:nil 
                                       target:self 
                                       selector:@selector(showWorlds)];
    
    
    CCMenuItemImage *optionsButton = [CCMenuItemImage 
                                      itemFromNormalImage:@"optionsW.png" 
                                      selectedImage:@"optionsB.png" 
                                      disabledImage:nil 
                                      target:self 
                                      selector:@selector(showOptions)];
    
    CCMenuItemImage *creditButton = [CCMenuItemImage 
                                      itemFromNormalImage:@"creditW.png" 
                                      selectedImage:@"creditB.png" 
                                      disabledImage:nil 
                                      target:self 
                                      selector:@selector(showCredit)];

    
    mainMenu = [CCMenu menuWithItems:playGameButton, optionsButton, creditButton, nil];
    //CCMenu is just a collection of CCMenuItems and they in turn define the various buttons or text labels as part of the Menu
    
    
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.06f];//spacing between the buttons
    [mainMenu setPosition: ccp(screenSize.width * -1.0f, screenSize.height * 0.6f)];
    
    id moveAction = [CCMoveTo actionWithDuration:2.0f position:ccp(screenSize.width * 0.85f, screenSize.height * 0.5f)];
    id moveEffect = [CCEaseElasticInOut actionWithAction:moveAction period:1.0f];
    [mainMenu runAction:moveEffect]; //the action will be applied on the menu buttons
    [self addChild:mainMenu z:0 tag:kMainMenuTagValue]; //adding the Menu we created to the Menu Layer
}

-(void)displaySceneSelection 
{
    [[GameManager sharedGameManager] runSceneWithID:kWorldsScene andScore:-1];
}

-(id) init 
{
    self = [super init];
    if (self != nil) 
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize; 
        
        [self displayMainMenu];
        
        //Add lable with the name of the game
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hit The Monster!" fontName:@"Arial" fontSize:70.0];
        label.position = ccp(screenSize.width/2, screenSize.height * 0.8);
        label.color = ccGREEN;
        [self addChild:label z:10];
        
        //Add shadow to the lable
        CCLabelTTF *ShadowLabel = [CCLabelTTF labelWithString:@"Hit The Monster!" fontName:@"Arial" fontSize:70.0];
        ShadowLabel.position = ccp(screenSize.width * 0.505, screenSize.height * 0.8);
        ShadowLabel.color = ccBLACK;
        [self addChild:ShadowLabel z:9];
        
        //Move the lables
        CCScaleTo *scaleUp = [CCScaleTo actionWithDuration:1 scale:1.2];
        CCScaleTo *scaleBack = [CCScaleTo actionWithDuration:1 scale:1.0];
        CCSequence *sequence = [CCSequence actions:scaleUp, scaleBack, nil];
        [label runAction:sequence];
        
        CCScaleTo *scaleUp2 = [CCScaleTo actionWithDuration:1 scale:1.2];
        CCScaleTo *scaleBack2 = [CCScaleTo actionWithDuration:1 scale:1.0];
        CCSequence *sequence2 = [CCSequence actions:scaleUp2, scaleBack2, nil];
        [ShadowLabel runAction:sequence2];
        
        //animation of a moving sprite followed by a particle effect
        CCSprite *sp1 = [CCSprite spriteWithFile:@"monster.png"];
		sp1.position = ccp(screenSize.width*0.1f, screenSize.height*0.1f);
		id move = [CCMoveBy actionWithDuration:3 position:ccp(screenSize.width*0.4f,screenSize.height*0.01f)];
		id move_ease_inout3 = [CCEaseInOut actionWithAction:[[move copy] autorelease] rate:2.0f];
		id move_ease_inout_back3 = [move_ease_inout3 reverse];
		id seq3 = [CCSequence actions: move_ease_inout3, move_ease_inout_back3, nil];
		[sp1 runAction: [CCRepeatForever actionWithAction:seq3]];
		[self addChild:sp1 z:7];
		
        CCParticleFlower *flower = [CCParticleFlower node];
		flower.position = ccp(screenSize.width*0.1f, (screenSize.height*0.1f)-50);
		id copy_seq3 = [[seq3 copy] autorelease];
        [flower runAction:[CCRepeatForever actionWithAction:copy_seq3]];
		[self addChild:flower z:100];
		
	}

    return self;
}

@end
