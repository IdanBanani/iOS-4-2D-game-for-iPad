//
//  Scene2.mm
//  

#import "Scene2.h"

@implementation Scene2

-(id) init 
{    
    self =[super init];
    if (self != nil) 
    {
        Level2 *level = [Level2 node];
        [self addChild:level z:5];
    }
    return self;
}

@end
