//
//  Obstacle.mm
//  

#import "Obstacle.h"

@implementation Obstacle

-(id) init 
{
    
    if ((self=[super init])) 
    {
        CCLOG(@"### Obstacle initialized");
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"obstacle2.png"]];
        gameObjectType = kObstacleType;
        [self setContentSize:CGSizeMake(self.contentSize.width * 0.75f, self.contentSize.height * 0.75f)];
        [self setScale:0.75f];
    } 
         
    return self;
}

@end
