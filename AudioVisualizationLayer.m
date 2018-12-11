//
//  AudioVisualizationLayer.m
//  for turn on and off the musec via the speaker image.

#import "AudioVisualizationLayer.h"
#import "GameManager.h"

enum 
{
	kTagBg,
	kTagHead,
};

@implementation AudioVisualizationLayer

// on "init" you need to initialize your instance
-(id) init
{
    self = [super init];
    if (self != nil) 
    {
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		self.isTouchEnabled=YES;
		
		// add the label as a child to this Layer
        
        if ([[GameManager sharedGameManager] isPlayingFirstTime])
        {
            [[GameManager sharedGameManager] playBackgroundTrack:BACKGROUND_TRACK_MAIN_MENU];
            [[GameManager sharedGameManager] setIsPlayingFirstTime:NO];
        }
        
        if (!([[GameManager sharedGameManager] isMusicON])) 
        {
            [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        }
        
		CCSprite *sprite = [CCSprite spriteWithFile:@"head.png"];
		
		sprite.position =  ccp( size.width *0.9f , size.height*0.05f );
		sprite.anchorPoint = ccp(0.5f,0.f);
		sprite.tag = kTagHead;
        sprite.scale=0.8;
		[self addChild: sprite];
        
	}
	return self;
}

+ (CGPoint) locationFromTouch:(UITouch*)touch 
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (void) registerWithTouchDispatcher 
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (bool) isTouchForMe:(CGPoint)touchLocation 
{
	bool hit = false;
	for(CCNode * node in [self children])
    {
		if(node.tag == kTagHead) 
        {
			hit = CGRectContainsPoint([node boundingBox], touchLocation);
        }
    }
    return hit;
}

-(void)ccTouchBegan:(UITouch *)touche withEvent:(UIEvent *)event
{
    CGPoint location = [AudioVisualizationLayer locationFromTouch:touche];
    bool isTouchHandled = [self isTouchForMe:location];
    if (isTouchHandled) 
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
}


//	The callback when the avg power level changes it gives you a level amount from 0..1
- (void) avAvgPowerLevelDidChange:(float) level channel:(ushort) theChannel
{
	//	change the sprite scaling
    [self getChildByTag:kTagHead].scale = 1 + level * 0.5f;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

@end
