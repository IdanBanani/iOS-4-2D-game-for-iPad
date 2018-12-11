//
//  OptionsLayer.m
// 

#import "OptionsLayer.h"
#import "MainMenuScene.h"

@implementation OptionsLayer

-(id) init
{
	if ((self = [super init]))
	{
		// wait a short moment before creating the menu so we can see it scroll in
		[self schedule:@selector(createOptionsScene:) interval:1];
	}
	return self;
}

-(void) createOptionsScene:(ccTime)delta
{
	/* unschedule the selector, we only want this method to be called once
    _cmd is the method that is currently being invoked. So if self is the subject, _cmd is the verb.
    */
	[self unschedule:_cmd];     
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	// create a toggle item using two other menu items (toggle works with images, too)
	[CCMenuItemFont setFontName:@"STHeitiJ-Light"];
	[CCMenuItemFont setFontSize:40];
    
	CCMenuItemFont* toggleMusicOn = [CCMenuItemFont itemFromString:@"Music : On"];
	CCMenuItemFont* toggleMusicOff = [CCMenuItemFont itemFromString:@"Music : Off"];
    
    CCMenuItemToggle* musicItem; //for having two states for a text button
    
    if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
        //if music is currently playing,write it's on 
    {
        musicItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicItemTouched) items:toggleMusicOn, toggleMusicOff, nil];
    }
	else 
        //write "music off"
    {
        musicItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(musicItemTouched) items:toggleMusicOff, toggleMusicOn, nil];
    }
    
    
    //the same as above,but reffers to sounds effects
    CCMenuItemFont* toggleSoundEffectsOn = [CCMenuItemFont itemFromString:@"SoundEffects : On"];
	CCMenuItemFont* toggleSoundEffectsOff = [CCMenuItemFont itemFromString:@"SoundEffects : Off"];
	
    CCMenuItemToggle* SoundEffectsItem;
    
    if ([[GameManager sharedGameManager] isSoundEffectsON]) 
    {
        SoundEffectsItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(SoundEffectsItemTouched) items:toggleSoundEffectsOn, toggleSoundEffectsOff, nil];
    }
    else
    {
        SoundEffectsItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(SoundEffectsItemTouched) items: toggleSoundEffectsOff, toggleSoundEffectsOn, nil];
    }
    
    
	// create the menu using the items
	CCMenu* menu = [CCMenu menuWithItems:musicItem,SoundEffectsItem, nil];
	menu.position = CGPointMake(-(size.width / 2), size.height / 2);
	menu.tag = 100;
	[self addChild:menu]; //adding th menu to the layer
	
	// calling one of the align methods is important, otherwise all labels will occupy the same location
	[menu alignItemsVerticallyWithPadding:40];
	
	// use an action for a neat initial effect - moving the whole menu at once!
	CCMoveTo* move = [CCMoveTo actionWithDuration:2 position:CGPointMake(size.width / 2, size.height / 2)];
	CCEaseElasticOut* ease = [CCEaseElasticOut actionWithAction:move period:0.8f];
	[menu runAction:ease];
}

-(void) musicItemTouched
{
	if ([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
    {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        [[GameManager sharedGameManager] setIsMusicON:NO];
    }
    else 
    {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
        [[GameManager sharedGameManager] setIsMusicON:YES];
    }
}

-(void) SoundEffectsItemTouched
{
    if ([[GameManager sharedGameManager] isSoundEffectsON])
    {
        [[GameManager sharedGameManager] setIsSoundEffectsON:NO];
    }
    else 
    {
        [[GameManager sharedGameManager] setIsSoundEffectsON:YES];
    }
}

-(void) dealloc
{
	CCLOG(@"dealloc: %@", self);
    [super dealloc];
}

@end
