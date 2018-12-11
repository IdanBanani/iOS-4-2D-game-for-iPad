//
//  Eye.mm
//  

#import "Eye.h"

@implementation Eye

-(id) init 
{
    if ((self=[super init]))
    {
        CCLOG(@"### Eye initialized");
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"eye.png"]];
        gameObjectType = kEyeType;
    }
    return self;
}


@end
