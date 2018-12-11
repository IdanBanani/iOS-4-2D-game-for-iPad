//
//  Cannon.mm
//  

#import "Cannon.h"

@implementation Cannon

@synthesize firringAnim;

- (void) dealloc
{
    [firringAnim release];
    [super dealloc];
}

- (void) changeState:(CharacterStates)newState 
{
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) 
    {
        case kStateSpawning:
            CCLOG(@"### Cannon->spawning animation");
            break;
            
            
        case kStateBallFired:
            CCLOG(@"### Cannon->BallFired animation");
            action = [CCAnimate actionWithAnimation:firringAnim restoreOriginalFrame:YES];
            break;
            
            
        default:
            CCLOG(@"Unhandled state %d in Cannon", newState);
            break;
    }
    
    if (action != nil) 
    {
        [self runAction:action];
    }
}

-(void) initAnimation
{
    [self setFirringAnim:[self loadPlistForAnimationWithName:@"firringAnim" andClassName:NSStringFromClass([self class])]];
    
}

-(id) init 
{
    if ((self=[super init])) 
    {
        CCLOG(@"### Cannon initialized");
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"turtle2.png"]];
        gameObjectType = kCannonType;
        [self changeState:kStateSpawning];
        [self initAnimation];
    }
    return self;
}

@end
