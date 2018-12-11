//
//  Level4.mm
//  

#import "Level4.h"

@implementation Level4

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
        trys = 9;
        trys_left = trys;
        numOfTrampolin = 2;
        
        //load the image from the atlas
        [self initSceneAtlas];
        
        //creating and placing all the objects in the level
        for (int i = 900; i > 550; i-=80) 
        {
            [self createObstacleAtLocation:ccp(i,650)];
            [self createObstacleAtLocation:ccp(i,150)];
        }
        
        [self createObstacleAtLocation:ccp(450,220)];
        [self createObstacleAtLocation:ccp(450,300)];
        
        for (int i = 400; i > 300; i-=80) 
        {
            [self createObstacleAtLocation:ccp(i,400)];
        }    
        
        
        [self createMonsterAtLocation:ccp(350,300)];
        [self createCannonAtLocation:ccp(800, 400)];
        
        [self initTrampolinsArraywith:numOfTrampolin];
        CGPoint positions[] = {CGPointMake(150, 600),CGPointMake(150, 250)};
        [self createTrampolinsAtLocations:positions];
        
        [self addPullFeedback];
        
        [self scheduleUpdate];
        
    }
    return self;
}

@end
