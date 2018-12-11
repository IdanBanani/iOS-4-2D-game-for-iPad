//
//  CCBReader.h
//  done by cocosBuilder v1
//  for graphic manual design of a layer 

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum
{
    kCCBMemberVarAssignmentTypeNone = 0,
    kCCBMemberVarAssignmentTypeDocumentRoot = 1,
    kCCBMemberVarAssignmentTypeOwner = 2,
};

@interface CCBReader : NSObject 
{
    @private
}

+ (CCScene*) sceneWithNodeGraphFromFile:(NSString*) file;
+ (CCScene*) sceneWithNodeGraphFromFile:(NSString *)file owner:(id)owner;

+ (CCNode*) nodeGraphFromFile:(NSString*) file;
+ (CCNode*) nodeGraphFromFile:(NSString*) file owner:(id)owner;

+ (CCNode*) nodeGraphFromDictionary:(NSDictionary*) dict;
+ (CCNode*) nodeGraphFromDictionary:(NSDictionary*) dict owner:(NSObject*) owner;


+ (CCNode*) nodeGraphFromDictionary:(NSDictionary*) dict extraProps: (NSMutableDictionary*) extraProps assetsDir:(NSString*)path owner:(NSObject*)owner;
+ (CCNode*) ccObjectFromDictionary: (NSDictionary *)dict extraProps: (NSMutableDictionary*) extraProps assetsDir:(NSString*)path owner:(NSObject*)owner;

@end
