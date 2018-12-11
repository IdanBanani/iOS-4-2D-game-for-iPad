//
//  Scene4.mm
//  

#import "Scene4.h"

@implementation Scene4

-(id) init 
{    
    self =[super init];
    if (self != nil)
    {
        Level4 *level = [Level4 node];
        [self addChild:level z:5];
    }
    return self;
}

@end
