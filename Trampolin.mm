//
//  Trampolin.mm
// 

#import "Trampolin.h"

@implementation Trampolin

@synthesize isTouchingTrampolin;
@synthesize index;

@synthesize takingHitAnim;

- (void) dealloc
{
    [takingHitAnim release];
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
            CCLOG(@"### Trampoline %i ->spawning animation", [self index]);
            break;
            
            
        case kStateBallHitTrampolin:
            CCLOG(@"### Trampoline %i ->BallHitTrampolin animation", [self index]);
             action = [CCAnimate actionWithAnimation:takingHitAnim restoreOriginalFrame:YES];
            break;
            
            
        default:
            CCLOG(@"Unhandled state %d in Trampoline %i", newState, [self index]);
            break;
    }
    
    if (action != nil)
    {
        [self runAction:action];
    }
}

-(void) initAnimation 
{
    [self setTakingHitAnim:[self loadPlistForAnimationWithName:@"takingHitAnim" andClassName:NSStringFromClass([self class])]];
    
}


-(id) init
{
    if ((self=[super init]))
    {
        CCLOG(@"### Trampolin initialized");
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"jellyfish1.png"]];
        gameObjectType = kTrampolinType;
        isTouchingTrampolin = NO;
        index = -1;
        [self initAnimation];
        [self changeState:kStateSpawning];
    }
    return self;
}

@end
