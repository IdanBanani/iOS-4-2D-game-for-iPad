//
//  Trampolin.h
//  

#import <Foundation/Foundation.h>
#import "Box2DSprite.h"

@interface Trampolin : Box2DSprite 
{
    BOOL isTouchingTrampolin;
    int index;
    
    CCAnimation *takingHitAnim;
}

@property (nonatomic,readwrite) BOOL isTouchingTrampolin;
@property (nonatomic,readwrite) int index;

@property (nonatomic, retain) CCAnimation *takingHitAnim;

@end
