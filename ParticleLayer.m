//
//  ParticleLayer.m
//  

#import "ParticleLayer.h"
#import "cocos2d.h"

@implementation ParticleLayer

// This method is called right after the class has been instantiated
// by CCBReader. Do any additional initiation here. If no extra
// initialization is needed, leave this method out.

- (void) didLoadFromCCB
{    
    // Start rotating the burst sprite
    [sprtBurst runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:8.0f angle:360]]];
}

@end
