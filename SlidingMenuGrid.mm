//
//  SlidingMenuGrid
//  A Menu for selecting a game level
// We are about to inherit this class in LevelMenuLayer
#import "SlidingMenuGrid.h"

@implementation SlidingMenuGrid

//b-Bool,f-float,i-index
@synthesize padding;
@synthesize menuOrigin;
@synthesize touchOrigin;
@synthesize touchStop;
@synthesize bMoving;
@synthesize	fMoveDelta;
@synthesize fMoveDeadZone;
@synthesize iPageCount;
@synthesize iCurrentPage;
@synthesize fAnimSpeed;

//The menu will contain an array of items
-(id) initWithArray:(NSMutableArray*)items cols:(int)cols rows:(int)rows position:(CGPoint)pos padding:(CGPoint)pad 
{
	if ((self = [super init]))
	{
		self.isTouchEnabled = YES;
		
        //add the unarranged buttons to the layer 
		int z = 1;
		for (id item in items)
		{
			[self addChild:item z:z tag:z];
			++z;
		}
		
		padding = pad;
		iCurrentPage = 0; //index of initial current page
		bMoving = false;//static view at first
        menuOrigin = pos;
		fMoveDeadZone = 10; //how far you need to move your finger in order to switch page
		fAnimSpeed = 1;
        [self buildGrid:cols rows:rows]; //arrange the buttons
		self.position = menuOrigin;
	}
	
	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) buildGrid:(int)cols rows:(int)rows
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int col = 0, row = 0;
	for (CCMenuItem* item in self.children)
	{
		// Calculate the position of our menu item. 
		item.position = CGPointMake(self.position.x + col * padding.x + (iPageCount * winSize.width), self.position.y - row * padding.y);
		
		// Increment our positions for the next item(s).
		++col;
		if (col == cols) //move to a new blank row
		{
			col = 0;
			++row;
			
			if( row == rows ) //move to a new  blank page
			{
				iPageCount++;
				col = 0;
				row = 0;
			}
		}
	}
}


-(void) addChild:(CCMenuItem*)child z:(int)z tag:(int)aTag
{
	return [super addChild:child z:z tag:aTag];
}

-(CCMenuItem*) GetItemWithinTouch:(UITouch*)touch
{
	// Get the location of touch.
	CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
	
	// Parse all of our menu items and see if our touch exists within one.
	for (CCMenuItem* item in [self children])
	{
		CGPoint local = [item convertToNodeSpace:touchLocation];
		
		CGRect r = [item rect]; //the item bounding rectangle
		r.origin = CGPointZero; //position must be 0,0 if it's relative to shape.
		
		// If the touch was within this item. Return the item.
		if (CGRectContainsPoint(r, local))
		{
			return item;
		}
	}
	
	// Didn't touch an item.
	return nil;
}

// Run the action necessary to slide the menu grid to the current page.
- (void) moveToCurrentPage
{	
	// Perform the action
	id action = [CCMoveTo actionWithDuration:(fAnimSpeed*0.5) position:[self GetPositionOfCurrentPage]];
	[self runAction:action];
}


-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
    //priority: -1 for not stealing touches from other elements on screen
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	// Convert and store the location the touch began at.
	touchOrigin = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	
	// If we weren't in "waiting" state bail out.
	if (state != kCCMenuStateWaiting)
	{
		return NO;
	}
	
	// Activate the menu item if we are touching one.
	selectedItem = [self GetItemWithinTouch:touch];
	[selectedItem selected];
    state = kCCMenuStateTrackingTouch;
    return YES;
}


// Touch has ended. Process sliding of menu or press of menu item.
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	// User has been sliding the menu.
	if( bMoving )
	{
		bMoving = false;
		
		// Do we have multiple pages?
		if( iPageCount > 1 && (fMoveDeadZone < abs(fMoveDelta)))
		{
			// Are we going forward or backward?
			bool bForward = (fMoveDelta < 0) ? true : false;
			
			// Do we have a page available?
			if(bForward && (iPageCount>iCurrentPage+1))
			{
				// Increment currently active page.
				iCurrentPage++;
			}
			else if(!bForward && (iCurrentPage > 0))
			{
				// Decrement currently active page.
				iCurrentPage--;
			}
		}

		// Start sliding towards the current page.
		[self moveToCurrentPage];			
		
	}
    
	// User wasn't sliding menu and simply tapped the screen. Activate the menu item.
	else 
	{
		[selectedItem unselected];
		[selectedItem activate];
	}

	// Back to waiting state.
	state = kCCMenuStateWaiting;
}



-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[selectedItem unselected];
	
	state = kCCMenuStateWaiting;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	// Calculate the current touch point during the move.
	touchStop = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

	// Distance between the origin of the touch and current touch point.
	fMoveDelta = (touchStop.x - touchOrigin.x);

	// Set our new view position.
	[self setPosition:[self GetPositionOfCurrentPageWithOffset:fMoveDelta]];
	bMoving = true;
}

- (CGPoint) GetPositionOfCurrentPage
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	return CGPointMake((menuOrigin.x-(iCurrentPage*winSize.width)),menuOrigin.y);
}

- (CGPoint) GetPositionOfCurrentPageWithOffset:(float)offset
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	return CGPointMake((menuOrigin.x-(iCurrentPage*winSize.width)+offset),menuOrigin.y);
}


// Returns the swiping dead zone. 
- (float) GetSwipeDeadZone
{
	return fMoveDeadZone;
}

- (void) SetSwipeDeadZone:(float)fValue
{
	fMoveDeadZone = fValue;
}



@end