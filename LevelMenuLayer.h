//
//  LevelMenuLayer.h
//  Here we will select between the levels

#import "SlidingMenuGrid.h"

@interface LevelMenuLayer : SlidingMenuGrid
{
 
}

-(LevelMenuLayer*) LevelMenuLayer;
-(void) selectLevel:(int)level;
@end

