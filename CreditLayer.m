//
//  CreditLayer.m
// 

#import "CreditLayer.h"

@implementation CreditLayer

-(void) nothing 
{
    //made this in order to swallow touches on the text
}

-(id) init 
{
	self = [super init];
	if (self != nil)
    {
		CGSize screenSize = [CCDirector sharedDirector].winSize; 
		
		CCLabelTTF *row1 = [CCLabelTTF labelWithString:@"This is Liav Sitruk & Idan Bannani Project" 
                                              fontName:@"MarkerFelt-Wide" fontSize:50];
		CCLabelTTF *row2 = [CCLabelTTF labelWithString:@"Supervisor: Aaron Wetzler" 
                                              fontName:@"MarkerFelt-Wide" fontSize:50];
		CCLabelTTF *row3 = [CCLabelTTF labelWithString:@"Networked Software System Lab" 
                                              fontName:@"MarkerFelt-Wide" fontSize:50];
        
        //setting the initial text labels positions
        [row1 setPosition:ccp(screenSize.width * 0.5f, screenSize.height * -0.1f)];
        [row2 setPosition:ccp(screenSize.width * 0.5f, screenSize.height * -0.3f)];
        [row3 setPosition:ccp(screenSize.width * 0.5f, screenSize.height * -0.5f)];
        
        //the text above will scroll up in constant speed
        id moveAction1 = [CCMoveTo actionWithDuration:8.0f position:ccp(screenSize.width*0.5f, screenSize.height*0.7f)];
        [row1 runAction:moveAction1];
        id moveAction2 = [CCMoveTo actionWithDuration:8.0f position:ccp(screenSize.width*0.5f, screenSize.height*0.5f)];
        [row2 runAction:moveAction2];
        id moveAction3 = [CCMoveTo actionWithDuration:8.0f position:ccp(screenSize.width*0.5f, screenSize.height*0.3f)];
        [row3 runAction:moveAction3];
        
        [self addChild:row1];
        [self addChild:row2];
        [self addChild:row3];
     
	}
	return self;
}

@end
