//
//  Ball.mm
//  

#import "Ball.h"

@implementation Ball


- (void) changeState:(CharacterStates)newState 
{
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState)
    {
        case kStateSpawning:
            CCLOG(@"Ball->starting the spawning animation");
            break;
            
        case kStateDead:
            CCLOG(@"Ball->changing state to Dead");
            [self setVisible:NO];
            body->GetWorld()->DestroyBody(body);
            body = NULL;
            break;
            
        case kStateBallHitTrampolin:
            CCLOG(@"Ball->changing state to BallHitTrampolin animation");
            break;
            
        default:
            CCLOG(@"Unhandled state %d in Ball", newState);
            break;
    }
    
    if (action != nil) 
    {
        [self runAction:action];
    }
}


-(id) init
{
    if ((self=[super init])) 
    {
        CCLOG(@"### Ball initialized");
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ball.png"]];
        gameObjectType = kBalltype;
        [self changeState:kStateSpawning];
    }
    return self;
}

@end
