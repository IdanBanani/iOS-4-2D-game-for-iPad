//
//  WinLayer.h
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"
#import "cocos2d.h"

@interface WinLayer : CCLayer 
{
    int score;
}

@property (nonatomic,readwrite) int score; 

-(id) initWithScore:(int)score1;

@end
