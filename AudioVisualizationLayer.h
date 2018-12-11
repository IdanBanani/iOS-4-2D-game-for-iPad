//
//  AudioVisualizationLayer.h
//  for turn on and off the music via the speaker image.

#import "cocos2d.h"

@interface AudioVisualizationLayer : CCLayer
{
    
}

+ (CGPoint) locationFromTouch:(UITouch*)touch;
- (void) registerWithTouchDispatcher;
- (bool) isTouchForMe:(CGPoint)touchLocation;
- (void) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent*)event;


@end
