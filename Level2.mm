//
//  Level2.mm
//  

#import "Level2.h"

@implementation Level2

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
        trys = 5;
        trys_left = trys;
        numOfTrampolin = 1;    
        
        //load the image from the atlas
        [self initSceneAtlas];
        
        //creating and placing all the objects in the level
        [self createObstacleAtLocation:ccp(500,650)];
        [self createObstacleAtLocation:ccp(500,585)];
        [self createObstacleAtLocation:ccp(500,520)];
        [self createObstacleAtLocation:ccp(500,455)];
        [self createObstacleAtLocation:ccp(500,390)];
        
        [self createObstacleAtLocation:ccp(200,295)];
        [self createObstacleAtLocation:ccp(200,230)];
        [self createObstacleAtLocation:ccp(200,165)];
        [self createObstacleAtLocation:ccp(200,100)];
        
        [self createMonsterAtLocation:ccp(150,650)];
        [self createCannonAtLocation:ccp(800, 550)];
        
        [self initTrampolinsArraywith:numOfTrampolin];
        CGPoint positions[] = {CGPointMake(500, 120)};
        [self createTrampolinsAtLocations:positions];
        
        [self addPullFeedback];
        
        [self scheduleUpdate];
        
    }
    return self;
}

@end
