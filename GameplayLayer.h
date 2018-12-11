//
//  GameplayLayer.h
// This is the heart of the game. it resposible for all the physics in the game, 
// creating the objects and update them.  

#import "CCLayer.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "GameManager.h"
#import "Constants.h"
#import "CommonProtocols.h"
#import "GLES-Render.h"
#import "Ball.h"
#import "Obstacle.h"
#import "Monster.h"
#import "Eye.h"
#import "Cannon.h"
#import "Trampolin.h"
#import "ShatteredSprite.h"

@interface GameplayLayer : CCLayer 
{
    b2World * world;
    GLESDebugDraw * debugDraw;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    
    Box2DSprite *ballSprite;
    Box2DSprite *cannonSprite;
    Box2DSprite *monsterSprite;
    Box2DSprite *REyeSprite;
    Box2DSprite *LEyeSprite;
    
    b2Body *ballBody;
    b2Body *cannonBody;
    b2Body *monsterBody;
    b2Body *REyeBody;
    b2Body *LEyeBody;
    b2Body *groundBody;
    
    NSMutableArray* trampolinsArray;
    
    int trys;
    int trys_left;
    int numOfTrampolin;
    int score;
    
    BOOL isDragging; //for the cannon
    BOOL ballFired;
    BOOL nextBall;
    BOOL gameOver;
    BOOL hasWon;
    BOOL hasLose;
    
    //for the pullyBack
    CCNode* feedbackContainer;
    NSMutableArray* feedback;
   
}

@property (nonatomic,retain) CCNode* feedbackContainer;
@property (nonatomic,retain) NSMutableArray* feedback;
@property (nonatomic,retain) NSMutableArray* trampolinsArray;
@property (nonatomic,readwrite) int score;


+(id) scene;
-(void) ballCount;
-(void) instructions;
-(void) win;
-(void) lose;
-(int) calcScore;
-(void) update:(ccTime)deltaTime;
-(void) setupWorld;
-(void) setupDebugDraw;
-(void) createGround;
-(void) createBodyAtLocation:(CGPoint)location forSprite:(Box2DSprite *)sprite friction:(float32)friction      
                 restitution:(float32)restitution density:(float32)density isBox:(BOOL)isBox fromType:(b2BodyType)type;

-(void) createObstacleAtLocation:(CGPoint)location;
-(void) createBall;
-(void) createMonsterAtLocation:(CGPoint)location;
-(void) createREyeAtLocation:(CGPoint)location;
-(void) createLEyeAtLocation:(CGPoint)location;
-(Trampolin*) createTrampolinAtLocation:(CGPoint)location withIndex:(int)index;
-(void) createTrampolinsAtLocations:(CGPoint[]) positions;
-(void) createCannonAtLocation:(CGPoint)location;

-(void) initSceneAtlas;
-(void) registerWithTouchDispatcher;

-(void) applyForceToBall:(CGPoint)touchPos;
-(void) updateBodyAngle:(CGPoint)point forBody:(b2Body *)body witeSprite:(Box2DSprite *)sprite;
-(void) initTrampolinsArraywith:(int) num;

-(void) addPullFeedback;
-(void) updatePullFeedback:(CGPoint)point;

-(BOOL) isTouching:(GameObject*)gameObject atPoint:(CGPoint)point;
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;

-(void) addFire;
-(void) addPoofEffectAt:(CGPoint)point;
-(void)doShatter;

-(void) draw;
-(void) dealloc;

@end
