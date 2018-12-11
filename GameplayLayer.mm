//
//  GameplayLayer.m
//

#import "GameplayLayer.h"
#import "SimpleQueryCallback.h"
#import "Box2DSprite.h"

@implementation GameplayLayer 

@synthesize feedbackContainer;
@synthesize feedback;
@synthesize trampolinsArray;
@synthesize score;

+(id) scene 
{
    CCScene *scene = [CCScene node];
    GameplayLayer *layer = [self node];
    [scene addChild:layer];
    return scene;
}

//add and upadte the lable of the balls counting
-(void) ballCount
{
    [self removeChildByTag:kBallsLeftTagValue cleanup:YES];
    CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"balls left: %i / %i", trys_left, trys]  
                                           fontName:@"Arial" fontSize:48.0];
    label.position = ccp(200, 740);
    label.scale = 0.8;
    [self addChild:label z:11 tag:kBallsLeftTagValue];
}

//explain the goal of the game
-(void) instructions
{    
    CGSize winSize = [[CCDirector sharedDirector] winSize];        
    int delta = 70.0;
    
    CCLabelTTF *trampolinLabel = [CCLabelTTF labelWithString:@"Press the trampoline and spin it!" fontName:@"Arial" fontSize:40.0];
    Box2DSprite* trampolin = [trampolinsArray objectAtIndex:0];
    trampolinLabel.position = CGPointMake(winSize.width * -0.5, 100*trampolin.body->GetPosition().y + delta);
    [self addChild:trampolinLabel z:10];
    
    CCLabelTTF *CannonLabel = [CCLabelTTF labelWithString:@"Press the cannon, spin it and shot!" fontName:@"Arial" fontSize:40.0];
    CannonLabel.position = CGPointMake(winSize.width * 1.5, cannonSprite.position.y + delta); 
    [self addChild:CannonLabel z:10];
    
    CCLabelTTF *MonsterLabel = [CCLabelTTF labelWithString:@"Hit The Monster!" fontName:@"Arial" fontSize:40.0];
    MonsterLabel.position = CGPointMake(winSize.width * 1.5, monsterSprite.position.y + delta);   
    [self addChild:MonsterLabel z:10];
   
    //Move the labels
    CCDelayTime *delay = [CCDelayTime actionWithDuration:3.0];
    CCFadeOut *fadeout = [CCFadeOut actionWithDuration:0.5];
    
    CCMoveTo *moveTrampolin = [CCMoveTo actionWithDuration:1.0 position:CGPointMake(100*trampolin.body->GetPosition().x,
                                                                        100*trampolin.body->GetPosition().y + delta)];
    
    CCSequence *sequenceTrampolin = [CCSequence actions: moveTrampolin, delay, fadeout, nil];
    [trampolinLabel runAction:sequenceTrampolin];
    
    CCMoveTo *moveCannon = [CCMoveTo actionWithDuration:1.0 position:CGPointMake(cannonSprite.position.x,
                                                                                 cannonSprite.position.y + delta)];
    CCSequence *sequenceCannon = [CCSequence actions: delay, moveCannon, delay, fadeout, nil];
    [CannonLabel runAction:sequenceCannon];
   
    CCMoveTo *moveMonster = [CCMoveTo actionWithDuration:1.0 position:CGPointMake(monsterSprite.position.x - delta,
                                                                                  monsterSprite.position.y + delta)];
    CCSequence *sequenceMonster = [CCSequence actions: delay, delay, moveMonster, delay, fadeout, nil];
    [MonsterLabel runAction:sequenceMonster];
}

-(void) win 
{    
    [self unschedule:_cmd]; //we want to call this function only once
    score = [self calcScore];
    [[GameManager sharedGameManager] runSceneWithID:kWonLevel andScore:score];
}

-(void) lose
{
    [self unschedule:_cmd]; //we want to call this function only once
    [[GameManager sharedGameManager] runSceneWithID:kLostLevel andScore:-1];
}

-(int) calcScore 
{
    CCLOG(@"### calc score");
    int points = 0;
    if (trys_left == trys)
    {
        points = 1000;
    }
    else 
    {
        float tmp = (float)trys_left / trys;
        tmp *= 1000;
        tmp = floorf(tmp);
        points = (int)tmp;
    }
    return points;
}

//this function update the state, place and so for all the objects in the game
-(void) update:(ccTime)deltaTime
{
    [self ballCount];
    
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    world->Step(deltaTime, velocityIterations, positionIterations);

    //update the position and the angle of all the bodys
    for (b2Body *b = world->GetBodyList(); b != NULL; b = b->GetNext()) 
    {
        if (b->GetUserData() != NULL) 
        {
            Box2DSprite *sprite = (Box2DSprite *) b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            sprite.rotation = CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        }
    }
    
    //if the ball moving in the screen
    if (!gameOver && ballFired)
    {
        //rotet the monster eyes to the ball direction
        CGPoint ballPos = CGPointMake(ballBody->GetPosition().x*PTM_RATIO,ballBody->GetPosition().y*PTM_RATIO);
        [self updateBodyAngle:ballPos forBody:REyeBody witeSprite:REyeSprite];
        [self updateBodyAngle:ballPos forBody:LEyeBody witeSprite:LEyeSprite];
        
        ballBody->SetAngularVelocity(0);
        CCLOG(@"### Ball vilocity: (%f,%f)", ballBody->GetLinearVelocity().x,ballBody->GetLinearVelocity().y);
        //if the ball is too slow - stop him
        if (ABS(ballBody->GetLinearVelocity().x) < 0.6 && ABS(ballBody->GetLinearVelocity().y) < 0.6 ) 
        {
            CCLOG(@"### ball stoped");
            --trys_left;
            nextBall = true;
            ballFired = false;
            [ballSprite setVisible:NO];
            CGPoint point = ballSprite.position;
            [self addPoofEffectAt:point];
            ballBody->GetWorld()->DestroyBody(ballBody);
            ballBody = NULL;
        }
        else 
        {
            //check if the ball hit the monster or the ground
            b2ContactEdge* edge = ballBody->GetContactList();
            while (edge)
            {
                //rotet the monster eyes to the ball direction
                CGPoint ballPos2 = CGPointMake(ballBody->GetPosition().x*PTM_RATIO,ballBody->GetPosition().y*PTM_RATIO);
                [self updateBodyAngle:ballPos2 forBody:REyeBody witeSprite:REyeSprite];
                [self updateBodyAngle:ballPos2 forBody:LEyeBody witeSprite:LEyeSprite];
                
                b2Contact* contact = edge->contact;
                b2Fixture* fixtureA = contact->GetFixtureA();
                b2Fixture* fixtureB = contact->GetFixtureB();
                b2Body *bodyA = fixtureA->GetBody();
                b2Body *bodyB = fixtureB->GetBody();
                
                if (bodyA == monsterBody || bodyB == monsterBody) 
                { 
                    CCLOG(@"### ball hit monster");
                    gameOver = true;
                    hasWon = true;
                    hasLose = false;
                    [ballSprite setVisible:NO];
                    [monsterSprite setVisible:NO];
                    [REyeSprite setVisible:NO];
                    [LEyeSprite setVisible:NO];
                    [self doShatter];
                    PLAYSOUNDEFFECT(BREAKING_GLASS_SOUND);
                    ballBody->GetWorld()->DestroyBody(ballBody);
                    ballBody = NULL;
                    break;
                }        
                if (bodyA == groundBody || bodyB == groundBody)
                {
                    CCLOG(@"### ball hit ground");
                    --trys_left;
                    nextBall = true;
                    ballFired = false;
                    [ballSprite setVisible:NO];
                    CGPoint point = ballSprite.position;
                    [self addPoofEffectAt:point];
                    [cannonSprite changeState:kStateSpawning];
                    ballBody->GetWorld()->DestroyBody(ballBody);
                    ballBody = NULL;
                    break;
                }
              
                //go over all the trampolines and change the state of the trampoline if the ball hit it
                for (int i=0; i < trampolinsArray.count; ++i) 
                {
                    Box2DSprite* s = [trampolinsArray objectAtIndex:i];
                    if (bodyA == s.body || bodyB == s.body)
                    {
                        CCLOG(@"### ball hit trampolin %i",[(Trampolin*)s index]);
                        if (!([s characterState] == kStateBallHitTrampolin))
                        {
                             [s changeState:kStateBallHitTrampolin];
                        }
                    }
                    else if (!([s characterState] == kStateSpawning))
                    {
                        [s changeState:kStateSpawning];
                    }

                }

                edge = edge->next;
            }
        }
        
        //check if game is over
        if (trys_left == 0 && !gameOver) 
        {
            gameOver = true;
            hasWon = false;
            hasLose = true;
        }
        
        if (hasWon) 
        {
            [self schedule:@selector(win) interval:2];
        }
        else if (hasLose) 
        {
            [self schedule:@selector(lose) interval:1];
        }
    }
}

-(void) setupWorld 
{
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    BOOL doSleep = false;
    world = new b2World(gravity, doSleep);
}

//for debuging 
-(void) setupDebugDraw 
{
    debugDraw = new GLESDebugDraw(PTM_RATIO *[[CCDirector sharedDirector] contentScaleFactor]);
    world->SetDebugDraw(debugDraw);
    debugDraw->SetFlags(b2DebugDraw::e_shapeBit);
}

-(void) createGround 
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float32 margin = 0.1f;
    b2Vec2 lowerLeft = b2Vec2(margin/PTM_RATIO, margin/PTM_RATIO);
    b2Vec2 lowerRight = b2Vec2((winSize.width-margin)/PTM_RATIO,  margin/PTM_RATIO);
    b2Vec2 upperRight = b2Vec2((winSize.width-margin)/PTM_RATIO,(winSize.height-margin)/PTM_RATIO);
    b2Vec2 upperLeft = b2Vec2(margin/PTM_RATIO, (winSize.height-margin)/PTM_RATIO);
    
    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(0, 0);
    groundBody = world->CreateBody(&groundBodyDef);
    
    b2PolygonShape groundShape;    
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.shape = &groundShape;
    groundFixtureDef.density = 0.0;
    
    groundShape.SetAsEdge(lowerLeft, lowerRight);
    groundBody->CreateFixture(&groundFixtureDef);    
    groundShape.SetAsEdge(lowerRight, upperRight);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(upperRight, upperLeft);
    groundBody->CreateFixture(&groundFixtureDef);
    groundShape.SetAsEdge(upperLeft, lowerLeft);
    groundBody->CreateFixture(&groundFixtureDef);
}

#pragma mark - creates
-(void) createBodyAtLocation:(CGPoint)location forSprite:(Box2DSprite *)sprite friction:(float32)friction      
                 restitution:(float32)restitution density:(float32)density isBox:(BOOL)isBox fromType:(b2BodyType)type 
{
    
    b2BodyDef bodyDef;
    bodyDef.type = type;
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    bodyDef.allowSleep = false;
    b2Body *body = world->CreateBody(&bodyDef);
    body->SetUserData(sprite);
    sprite.body = body;
    
    b2FixtureDef fixtureDef;
    
    if (isBox) 
    {
        b2PolygonShape shape;
        if (sprite.gameObjectType == kTrampolinType) 
        {
             shape.SetAsBox(sprite.contentSize.width/2.5/PTM_RATIO, sprite.contentSize.height/7/PTM_RATIO);
        }
        else 
        {
            shape.SetAsBox(sprite.contentSize.width/3/PTM_RATIO, sprite.contentSize.height/2/PTM_RATIO);
        }
            
        fixtureDef.shape = &shape;
    } 
    else 
    {
        b2CircleShape shape;  
        if (sprite.gameObjectType == kMonsterType) 
        {
            shape.m_radius = sprite.contentSize.width/4/PTM_RATIO;
        }
        else
        {
            shape.m_radius = sprite.contentSize.width/2.5/PTM_RATIO;
        }
        
        fixtureDef.shape = &shape;
    }    
    
    fixtureDef.density = density;
    fixtureDef.friction = friction;
    fixtureDef.restitution = restitution;
     
    //set the cannon and the monster eyes as sensors
    if (sprite.gameObjectType == kCannonType || sprite.gameObjectType == kEyeType)
    {
        fixtureDef.isSensor = true;
    }
    
    body->CreateFixture(&fixtureDef);   
    
}

//functions to create and place the game object
-(void) createObstacleAtLocation:(CGPoint)location 
{
    Obstacle *sprite = [Obstacle node];
    [self createBodyAtLocation:location forSprite:sprite friction:1.0 restitution:0.0 density:0 isBox:TRUE fromType:b2_staticBody];
    [sceneSpriteBatchNode addChild:sprite z:self.zOrder tag:kObstacleTagValue];
}

-(void) createBall 
{
    CGPoint cannonPos = cannonSprite.position;
    float angle = CC_RADIANS_TO_DEGREES(cannonBody->GetAngle());
    int r = 120;
    CGPoint p =  CGPointMake(cannonPos.x + r * cos(CC_DEGREES_TO_RADIANS(angle)) , cannonPos.y + r * sin(CC_DEGREES_TO_RADIANS(angle)));
    
    Ball *sprite = [Ball node];
    [self createBodyAtLocation:p forSprite:sprite friction:1.0 restitution:0.5 density:1.0 isBox:FALSE fromType:b2_dynamicBody];
    [sceneSpriteBatchNode addChild:sprite z:self.zOrder tag:kBallTagValue];
    ballBody = sprite.body;
    ballSprite = sprite;
    ballSprite.position = p;
    ballBody->SetLinearVelocity(b2Vec2_zero);
}

-(void) createMonsterAtLocation:(CGPoint)location 
{
    Monster *sprite = [Monster node];
    [self createBodyAtLocation:location forSprite:sprite friction:1.0 restitution:0.0 density:0.0 isBox:FALSE fromType:b2_staticBody];
    [sceneSpriteBatchNode addChild:sprite z:self.zOrder tag:kMonsterTagValue];
    monsterBody = sprite.body;
    monsterSprite = sprite;
    monsterSprite.position = location;
    [self createREyeAtLocation:CGPointMake(location.x + 25, location.y + 1)];
    [self createLEyeAtLocation:CGPointMake(location.x - 17, location.y + 4)];
}


-(void) createREyeAtLocation:(CGPoint)location 
{
    Eye *sprite = [Eye node];
    [self createBodyAtLocation:location forSprite:sprite friction:1.0 restitution:0.0 density:0.0 isBox:FALSE fromType:b2_dynamicBody];
    [sceneSpriteBatchNode addChild:sprite z:self.zOrder+1 tag:kEyeTagValue];
    REyeBody = sprite.body;
    REyeSprite = sprite;
    REyeSprite.position = location;
    [REyeSprite setScale:0.8];
}

-(void) createLEyeAtLocation:(CGPoint)location
{
    Eye *sprite = [Eye node];
    [self createBodyAtLocation:location forSprite:sprite friction:1.0 restitution:0.0 density:0.0 isBox:FALSE fromType:b2_dynamicBody];
    [sceneSpriteBatchNode addChild:sprite z:self.zOrder+1 tag:kEyeTagValue];
    LEyeBody = sprite.body;
    LEyeSprite = sprite;
    LEyeSprite.position = location;
    [LEyeSprite setScale:1.1];
}

-(Trampolin*) createTrampolinAtLocation:(CGPoint)location withIndex:(int)index
{
    Trampolin *sprite = [Trampolin node];
    [sprite setIndex:index];
    [self createBodyAtLocation:location forSprite:sprite friction:1.0 restitution:0.5 density:0.0 isBox:TRUE fromType:b2_staticBody];
    [sceneSpriteBatchNode addChild:sprite z:self.zOrder tag:kTrampolinTagValue];
    
    return sprite;
}

//init the trampolines array 
-(void) createTrampolinsAtLocations:(CGPoint[]) positions 
{
    for (int i=0; i<numOfTrampolin; ++i) 
    {
        Trampolin* tramp = [self createTrampolinAtLocation:positions[i] withIndex:i];
        [trampolinsArray addObject:tramp];
    }
}

-(void) createCannonAtLocation:(CGPoint)location 
{
    Cannon *sprite = [Cannon node];
    [self createBodyAtLocation:location forSprite:sprite friction:1.0 restitution:0.0 density:1.0 isBox:FALSE fromType:b2_dynamicBody];
    [sceneSpriteBatchNode addChild:sprite z:self.zOrder tag:kCannonTagValue];
    cannonBody = sprite.body;
    cannonSprite = sprite;
    cannonSprite.position = location;
    
}

-(void) initSceneAtlas 
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlasScene_default.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"poof.plist"];
    sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"atlasScene_default.png"];
    [self addChild:sceneSpriteBatchNode z:0];
}

#pragma mark -
-(void) registerWithTouchDispatcher 
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

#pragma mark - force and angle
-(void) applyForceToBall:(CGPoint)touchPos 
{
	CGFloat forceModifier = 0.075;

	CGPoint heroPos = ballSprite.position;
    b2Vec2 b2v_heroPos = b2Vec2(heroPos.x,heroPos.y);

    CGPoint slope = CGPointMake(heroPos.x - touchPos.x, heroPos.y - touchPos.y);
    b2Vec2 force = b2Vec2(slope.x * forceModifier, slope.y * forceModifier); 
    
	ballBody->ApplyForce(force, b2v_heroPos);
}

//upate the angle of body when the player spin it 
-(void) updateBodyAngle:(CGPoint)point forBody:(b2Body *)body witeSprite:(Box2DSprite *)sprite
{
    CGPoint heroPos = CGPointMake(body->GetPosition().x*PTM_RATIO,body->GetPosition().y*PTM_RATIO);
    b2Vec2 toTarget = b2Vec2(point.x - heroPos.x, point.y - heroPos.y);
    float desiredAngle = atan2f( toTarget.y, toTarget.x );
    
    float desiredAngleInDeg = CC_RADIANS_TO_DEGREES(desiredAngle);
    
    if (sprite.gameObjectType == kCannonType) 
    {
        desiredAngleInDeg += 180;
    }
    
    while (desiredAngleInDeg < 0) 
    {
        desiredAngleInDeg += 360;
    }
    
    while (desiredAngleInDeg > 360) 
    {
        desiredAngleInDeg -= 360;
    }
    
    desiredAngle = CC_DEGREES_TO_RADIANS(desiredAngleInDeg);
    
    b2Vec2 pos = body->GetPosition();
    body->SetTransform(pos,desiredAngle);
       
    if (sprite.gameObjectType == kCannonType)
    {
        if (desiredAngleInDeg > 90 && desiredAngleInDeg < 270) 
        {
            [cannonSprite setFlipY:YES];
        }
        else 
        {
            [cannonSprite setFlipY:NO];
        }
    }
}

-(void) initTrampolinsArraywith:(int) num 
{
    self.trampolinsArray =  [NSMutableArray arrayWithCapacity:num];
}

#pragma mark - pull
// this two function create and upate the white dots that point for the general direction of the ball path
-(void) addPullFeedback 
{
	self.feedback = [NSMutableArray arrayWithCapacity:5];
	self.feedbackContainer = [CCNode node];
	self.feedbackContainer.visible = false;
	[self addChild:self.feedbackContainer];
	for (int i=0; i<5; i++)
    {
		CCSprite* dot = [CCSprite spriteWithSpriteFrameName:@"dot1.png"];
        [self.feedbackContainer addChild:dot];
		[self.feedback addObject:dot];
	}
    CCLOG(@"### addPullFeedback");
}

-(void) updatePullFeedback:(CGPoint)point 
{
    [self updateBodyAngle:point forBody:cannonBody witeSprite:cannonSprite];
    
    self.feedbackContainer.visible = true;
    //Draw the dots within the container in a line between the hero and the touch point
    CGFloat magnitude = 0.0;
    CGPoint heroPos = cannonSprite.position;
    //Get the (negative) slope of the line.
    CGPoint slope = CGPointMake(point.x - heroPos.x, point.y - heroPos.y);
    CGFloat increment = 1.0 / self.feedback.count;
    
    for(CCSprite* sprite in feedback) 
    {
        CGPoint p = CGPointMake(heroPos.x - (magnitude * slope.x), heroPos.y - (magnitude * slope.y)); //pullyFront
        sprite.position = p;
        magnitude += increment;
    }

}

#pragma mark - touch
-(BOOL) isTouching:(GameObject*)gameObject atPoint:(CGPoint)point 
{
	CGPoint gPos = gameObject.position;
	CGSize gSize = gameObject.contentSize;
    
	CGRect hitArea = CGRectMake(gPos.x - gSize.width/4, gPos.y - gSize.height/4, gSize.width/2, gSize.height/2); 
	if(CGRectContainsPoint(hitArea, point))
    {
		return YES;
	}
	return NO;
}

//this functions andle with the touch in the game
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //converting the cordinets of the touch place
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    
    b2AABB aabb;
    b2Vec2 delta = b2Vec2(1.0/PTM_RATIO, 1.0/PTM_RATIO);
    aabb.lowerBound = locationWorld - delta;
    aabb.upperBound = locationWorld + delta;
    SimpleQueryCallback callback(locationWorld);
    world->QueryAABB(&callback, aabb);
    
    //check if the player touched one of the bodys
    if (callback.fixtureFound) 
    {
        b2Body *body = callback.fixtureFound->GetBody();
        Box2DSprite *sprite = (Box2DSprite *) body->GetUserData();
        if (sprite == NULL) return FALSE;
          
        if (sprite.gameObjectType == kCannonType) 
        {
            NSLog(@"### Touched cannon...");
            isDragging = true;
            [self updatePullFeedback:touchLocation];
        }
        
        if (sprite.gameObjectType == kTrampolinType)
        {
            int index = [(Trampolin*)sprite index];
            NSLog(@"### Touched trampolin %i", index);
            [(Trampolin*)sprite setIsTouchingTrampolin:YES];
            Box2DSprite* s = [trampolinsArray objectAtIndex:index];
            [self updateBodyAngle:touchLocation forBody:s.body witeSprite:s];
        }
    }
    
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event 
{    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
   
    if (isDragging) //for the cannon
    {
        [self updatePullFeedback:touchLocation];
    }
    else 
    {
        for (int i=0; i < trampolinsArray.count; ++i) 
        {
            Box2DSprite* trampolineSprite = [trampolinsArray objectAtIndex:i];
            if ([(Trampolin*)trampolineSprite isTouchingTrampolin])
            {
                 CCLOG(@"### move trampoline %i",[(Trampolin*)trampolineSprite index]);
                [self updateBodyAngle:touchLocation forBody:trampolineSprite.body witeSprite:trampolineSprite];
            }
        }
    }
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CGPoint loc = [touch locationInView: [touch view]];
    loc = [[CCDirector sharedDirector] convertToGL: loc];
    loc = [self convertToNodeSpace:loc];
        
    if ([self isTouching:cannonSprite atPoint:loc])
    {
        CCLOG(@"### canceling drag");
    }
    else 
    {
        if (isDragging && nextBall) 
        {
            CCLOG(@"### ball fired");
            [self createBall];    
            [self applyForceToBall:loc];
            [self addFire];
            [cannonSprite changeState:kStateBallFired];
            ballFired = true;
            nextBall = false;
        }
    }
   
    self.feedbackContainer.visible = false;
    isDragging = false;
    
    for (Trampolin* trampolin in trampolinsArray)
    {
        [trampolin setIsTouchingTrampolin:NO];
    }
    
    CCLOG(@"### touch Ended");
}

//add the fire particle - when the ball fired 
-(void) addFire 
{
    CGPoint cannonPos = cannonSprite.position;
    float angle = CC_RADIANS_TO_DEGREES(cannonBody->GetAngle());
    int r = 120;
    CGPoint p =  CGPointMake(cannonPos.x + r * cos(CC_DEGREES_TO_RADIANS(angle)) , cannonPos.y + r * sin(CC_DEGREES_TO_RADIANS(angle)));
    
    CCParticleSun *fire = [[CCParticleSun alloc] initWithTotalParticles:100];
    fire.autoRemoveOnFinish =YES;
    fire.startSize = 100.0f;
    fire.speed = 100.0f;
    fire.anchorPoint = ccp(0.5f, 0.5f);
    fire.position = p;
    fire.duration = 0.5f;
    
    [self addChild:fire z:self.zOrder+1];
    PLAYSOUNDEFFECT(EXPLOSION_SOUND);
}

//add the explotion effect - when the ball destroy
-(void) addPoofEffectAt:(CGPoint)point
{
	CCSprite* poof = [CCSprite spriteWithSpriteFrameName:@"poof1.png"];
	[self addChild:poof];
	poof.position = point;
    
	NSArray* poofNames = [NSArray arrayWithObjects:@"poof1.png", @"poof2.png", @"poof3.png", @"poof4.png", @"poof5.png", nil];
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:5];
	for(NSString* frameName in poofNames)
    {
		[frames addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
	}
	CCAnimation* animation = [CCAnimation animationWithFrames:frames delay:0.06];
	CCAnimate* animateAction = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO];
	CCCallFuncN* removeAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeNode:)];
	CCSequence* sequence = [CCSequence actions:animateAction, removeAction, nil];
	[poof runAction:sequence];
}

-(void)removeNode:(CCNode*)node
{
	[node removeFromParentAndCleanup:YES];
}

//do the break glass effect of the monster
-(void)doShatter 
{
	ShatteredSprite	*shatter = [ShatteredSprite shatterWithSprite:monsterSprite piecesX:5 piecesY:7 speed:0.5 rotation:0.02];	
	shatter.position = monsterSprite.position;
	[shatter runAction:[CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:5.0 position:ccp(0, -1000)]]];
    [shatter setScale:0.9];
	[self addChild:shatter z:1 tag:99];	    
}

//drow the images in the level
-(void) draw 
{
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    world->DrawDebugData();
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void) dealloc 
{
    if (world) 
    {
        delete world;
        world = NULL;
    }
    
    if (debugDraw) 
    {
        delete debugDraw;
        debugDraw = nil;
    }
    [super dealloc];
}

@end
