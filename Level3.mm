//
//  Level3.mm
//  

#import "Level3.h"

@implementation Level3

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
        trys = 8;
        trys_left = trys;
        numOfTrampolin = 2;
        
        //load the image from the atlas
        [self initSceneAtlas];
        
        //creating and placing all the objects in the level
        [self createObstacleAtLocation:ccp(600,650)];
        [self createObstacleAtLocation:ccp(600,585)];
        [self createObstacleAtLocation:ccp(600,520)];
        [self createObstacleAtLocation:ccp(600,455)];
        [self createObstacleAtLocation:ccp(600,390)];
        
        [self createObstacleAtLocation:ccp(300,295)];
        [self createObstacleAtLocation:ccp(300,230)];
        [self createObstacleAtLocation:ccp(300,165)];
        [self createObstacleAtLocation:ccp(300,100)];
        
        [self createMonsterAtLocation:ccp(150,150)];
        [self createCannonAtLocation:ccp(800, 450)];
        
        [self initTrampolinsArraywith:numOfTrampolin];
        CGPoint positions[] = {CGPointMake(600, 120),CGPointMake(230, 550)};
        [self createTrampolinsAtLocations:positions];
        
        [self addPullFeedback];
        
        [self scheduleUpdate];
        
    }
    return self;
}

@end
