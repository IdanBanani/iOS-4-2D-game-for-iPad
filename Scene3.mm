//
//  Scene3.mm
//  

#import "Scene3.h"

@implementation Scene3

-(id) init
{    
    self =[super init];
    if (self != nil)
    {
        Level3 *level = [Level3 node];
        [self addChild:level z:5];
    }
    return self;
}

@end
