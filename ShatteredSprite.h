//
// ShatteredSprite
//

#import "cocos2d.h"

//Can change this for what's really used...or really could alloc the memory too
//200 works for a 10x10 grid (with 2 triangles per square)
//128 = 8x8 *2
//98  = 7x7 *2
//64  = 6x6 *2
//50  = 5x5 *2
//32  = 4x4 *2
#define SHATTER_VERTEX_MAX	100


//Helper things, since it moves the triangles separately
typedef struct _TriangleVertices 
{
	CGPoint		pt1;
	CGPoint		pt2;
	CGPoint		pt3;
} TriangleVertices;

static inline TriangleVertices
tri(CGPoint	pt1, CGPoint pt2, CGPoint pt3) 
{
	TriangleVertices t = {pt1, pt2, pt3 };
	return t;
}

typedef struct _TriangleColors 
{
	ccColor4B		c1;
	ccColor4B		c2;
	ccColor4B		c3;
} TriangleColors;


//Subclass of CCSprite, so all the color & opacity things work by just overriding updateColor, and can use the sprite's texture too.
@interface ShatteredSprite : CCSprite 
{
	TriangleVertices	vertices[SHATTER_VERTEX_MAX];
    TriangleVertices	texCoords[SHATTER_VERTEX_MAX];
	TriangleColors		colorArray[SHATTER_VERTEX_MAX];
	
	float				adelta[SHATTER_VERTEX_MAX];
	CGPoint				vdelta[SHATTER_VERTEX_MAX];
	CGPoint				centerPt[SHATTER_VERTEX_MAX];
	
	NSInteger			numVertices;
}

+ (id) shatterWithSprite:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar;
- (id) initWithSprite:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar;

- (void)shatterSprite:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar;

@end
