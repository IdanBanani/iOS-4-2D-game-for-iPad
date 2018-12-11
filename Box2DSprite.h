//
//  Box2DSprite.h
//  

#import <Foundation/Foundation.h>
#import "GameCharacter.h"
#import "Box2D.h"


@interface Box2DSprite : GameCharacter 
{
    b2Body *body;
}

@property (assign) b2Body *body;


@end
