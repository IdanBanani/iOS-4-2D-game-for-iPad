//
// GameCharacter.h
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject 
{
    CharacterStates characterState;
}

@property (readwrite) CharacterStates characterState; 
@end
