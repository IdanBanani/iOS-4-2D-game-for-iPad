//
//  Cannon.h
//  

#import <Foundation/Foundation.h>
#import "Box2DSprite.h"

@interface Cannon : Box2DSprite 
{
    CCAnimation *firringAnim;
}

@property (nonatomic, retain) CCAnimation *firringAnim;
@end
