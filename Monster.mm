//
//  Monster.mm
// 

#import "Monster.h"

@implementation Monster

-(id) init 
{
    if ((self=[super init]))
    {
        CCLOG(@"### Monster initialized");
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"monster.png"]];
        gameObjectType = kMonsterType;
        [self setScale:0.9];
    }
    return self;
}

@end
