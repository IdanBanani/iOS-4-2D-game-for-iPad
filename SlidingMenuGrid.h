//
//  SlidingMenuGrid
//  A Menu Layer for selecting a game level
// We are about to inherit this class in LevelMenuLayer

#import "cocos2d.h"

@interface SlidingMenuGrid : CCLayer
{
	tCCMenuState state; // State of our menu grid. (Eg. waiting, tracking touch, cancelled, etc)
	CCMenuItem *selectedItem; // Menu item that was selected/active.
	
	CGPoint padding; // Padding in between menu items. 
	CGPoint menuOrigin; // Origin position of the entire menu grid.
	CGPoint touchOrigin; // Where the touch action began.
	CGPoint touchStop; // Where the touch action stopped.
	
	int iPageCount; // Number of pages in this grid.
	int iCurrentPage; // Current page of menu items being viewed.
	
	bool bMoving; // Is the grid currently moving?
	
	float fMoveDelta; // Distance from origin of touch and current frame.
	float fMoveDeadZone; // Amount the user need to slide the grid in order to move to a new page.
	float fAnimSpeed; // 0.0-1.0 value determining how slow/fast to animate the paging.
}


-(id) initWithArray:(NSMutableArray*)items cols:(int)cols rows:(int)rows position:(CGPoint)pos padding:(CGPoint)pad;
-(void) buildGrid:(int)cols rows:(int)rows;
-(CCMenuItem*) GetItemWithinTouch:(UITouch*)touch;
- (CGPoint) GetPositionOfCurrentPageWithOffset:(float)offset;
- (CGPoint) GetPositionOfCurrentPage;
- (float) GetSwipeDeadZone;
- (void) SetSwipeDeadZone:(float)fValue;

@property (nonatomic, readwrite) CGPoint padding;
@property (nonatomic, readwrite) CGPoint menuOrigin;
@property (nonatomic, readwrite) CGPoint touchOrigin;
@property (nonatomic, readwrite) CGPoint touchStop;
@property (nonatomic, readwrite) int iPageCount;
@property (nonatomic, readwrite) int iCurrentPage;
@property (nonatomic, readwrite) bool bMoving;
@property (nonatomic, readwrite) float fMoveDelta;
@property (nonatomic, readwrite) float fMoveDeadZone;
@property (nonatomic, readwrite) float fAnimSpeed;

@end