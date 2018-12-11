//
//  Level1.mm
//  

#import "Level1.h"

@implementation Level1

-(id) init
{
    self = [super init];
    if (self != nil) 
    {
        //setup the variables for the game level
        [self setupWorld];
        [self createGround];
        self.isTouchEnabled = YES;
        gameOver = false;
        ballFired = false;
        isDragging = false;
        nextBall = true;
        trys = 4;
        trys_left = trys;
        numOfTrampolin = 1;
        
        //load the image from the atlas
        [self initSceneAtlas];
        
        //creating and placing all the objects in the level
        [self createObstacleAtLocation:ccp(800,450)];
        [self createObstacleAtLocation:ccp(800,400)];
        [self createObstacleAtLocation:ccp(800,350)];
        [self createObstacleAtLocation:ccp(800,300)];
        [self createObstacleAtLocation:ccp(800,250)];
        
        [self createObstacleAtLocation:ccp(150,450)];
        [self createObstacleAtLocation:ccp(150,400)];
        [self createObstacleAtLocation:ccp(150,350)];
        [self createObstacleAtLocation:ccp(150,300)];
        [self createObstacleAtLocation:ccp(150,250)];
        
        [self createMonsterAtLocation:ccp(850,100)];
        [self createCannonAtLocation:ccp(700, 600)];
        
        [self initTrampolinsArraywith:numOfTrampolin];
        CGPoint positions[] = {CGPointMake(300, 400)};
        [self createTrampolinsAtLocations:positions];
        
        [self addPullFeedback];
        
        [self scheduleUpdate];
        
        //only show in the first level
        [self instructions]; 
        
    }
    return self;
}

@end
