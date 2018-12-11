//
//  Scene1.mm
//

#import "Scene1.h"

@implementation Scene1

-(id) init 
{    
    self =[super init];
    if (self != nil) 
    {
        Level1 *level = [Level1 node];
        [self addChild:level z:5];
    }
    return self;
}

@end
