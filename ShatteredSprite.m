//
//  ShatteredSprite
//

#import "ShatteredSprite.h"


#ifndef RANDF
//A helper to do float random numbers in a range around a base value.
float randf(float base, float range) 
{
	if (range==0) return base;
	long		lRange = rand()%(int)((range*2)*10000);
	float		fRange = ((float)lRange/10000.0) - range;
	return	base + fRange;
}
#endif


@implementation ShatteredSprite

+ (id)shatterWithSprite:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar 
{
    return [[[self alloc] initWithSprite:sprite piecesX:piecesX piecesY:piecesY speed:speedVar rotation:rotVar] autorelease];
}
- (id)initWithSprite:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar 
{
    self = [super init];
    if (self) {
        // Initialization code here.
		[self shatterSprite:sprite piecesX:piecesX piecesY:piecesY speed:speedVar rotation:rotVar];
		
		[self scheduleUpdate];
    }
    
    return self;
}

- (void)update:(ccTime)delta 
{
	//Note, does NOT adjust vdelta and adelta for slow frames;
	//To do that, need some d=(delta*60.0) that's multiplied by the vdelta and adelta
	for (int i = 0; i<numVertices; i++)
    {
		vertices[i].pt1 = ccpAdd(vertices[i].pt1, vdelta[i]);
		vertices[i].pt2 = ccpAdd(vertices[i].pt2, vdelta[i]);
		vertices[i].pt3 = ccpAdd(vertices[i].pt3, vdelta[i]);
		centerPt[i] = ccpAdd(centerPt[i], vdelta[i]);
		
		vertices[i].pt1 = ccpRotateByAngle(vertices[i].pt1, centerPt[i], adelta[i]);
		vertices[i].pt2 = ccpRotateByAngle(vertices[i].pt2, centerPt[i], adelta[i]);
		vertices[i].pt3 = ccpRotateByAngle(vertices[i].pt3, centerPt[i], adelta[i]);
	}
}

- (void)draw 
{	
	CC_ENABLE_DEFAULT_GL_STATES();
    
    glBindTexture(GL_TEXTURE_2D, self.texture.name);
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, colorArray);
	glDrawArrays(GL_TRIANGLES, 0, numVertices*3);	
}

- (void)updateColor 
{
	//Update the color array...
	ccColor4B color4 = { color_.r, color_.g, color_.b, opacity_ };	
	TriangleColors	triColor4 = { color4, color4, color4 };
	for (int i=0; i<numVertices; i++) 
    {
		colorArray[i] = triColor4;
	}
}

- (void)shatterSprite:(CCSprite*)sprite piecesX:(NSInteger)piecesX piecesY:(NSInteger)piecesY speed:(float)speedVar rotation:(float)rotVar 
{
	//Do rendertexture to make a whole new texture, so not part of the textureCache
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:sprite.contentSizeInPixels.width height:sprite.contentSizeInPixels.height];
	[rt begin];	
	CCSprite *s2 = [CCSprite spriteWithTexture:sprite.texture rect:sprite.textureRect];
	s2.position = ccp(sprite.contentSizeInPixels.width/2, sprite.contentSizeInPixels.height/2);
	[s2 visit];	
	[rt end];
	
	//Uses the Sprite's texture to reuse things.
	[self setTexture:rt.sprite.texture];
	[self setTextureRect:CGRectMake(0, 0, sprite.contentSizeInPixels.width, sprite.contentSizeInPixels.height)];

	//Sizey thingys
	float	wid = sprite.contentSizeInPixels.width;
	float	hgt = sprite.contentSizeInPixels.height;
	float	pieceXsize = wid/(float)piecesX;
	float	pieceYsize = hgt/(float)piecesY;
	float	texWid = wid/self.texture.pixelsWide;
	float	texHgt = hgt/self.texture.pixelsHigh;
	
	ccColor4B		color4 = {color_.r, color_.g, color_.b, opacity_ };
	TriangleColors	triColor4 = { color4, color4, color4 };
	
	//Build the points first, so they can be wobbled a bit to look more random...
	CGPoint			ptArray[piecesX+1][piecesY+1];
	for (int x=0; x<=piecesX; x++) 
    {
		for (int y=0; y<=piecesY; y++) 
        {
			CGPoint			pt = CGPointMake((x*pieceXsize), (y*pieceYsize));
			//Edge pieces aren't wobbled, just interior.
			if (x>0 && x<piecesX && y>0 && y<piecesY) 
            {
				pt = ccpAdd(pt, ccp(roundf(randf(0.0, pieceXsize*0.45)), roundf(randf(0.0, pieceYsize*0.45))));
			}
			ptArray[x][y] = pt;
		}
	}
	
	numVertices = 0;
    
	for (int x=0; x<piecesX; x++)
    {
		for (int y=0; y<piecesY; y++)
        {
			if (numVertices>=SHATTER_VERTEX_MAX)
            {
				NSLog(@"NeedABiggerArray!");
				return;
			}
			
			//Direction (v) and rotation (a) are done by triangle too.
			//CenterPoint is for rotating each triangle
			//vdelta is random, but could be done based on distance/direction from the center of the image to explode out...
			vdelta[numVertices] = ccp(randf(0.0, speedVar), randf(0.0, speedVar));
			adelta[numVertices] = randf(0.0, rotVar);
			colorArray[numVertices] = triColor4;			
			centerPt[numVertices] = ccp((x*pieceXsize)+(pieceXsize*0.3), (y*pieceYsize)+(pieceYsize*0.3)); 

			vertices[numVertices] = tri(ptArray[x][y], 
										ptArray[x+1][y], 
										ptArray[x][y+1]);
			texCoords[numVertices++] = tri(ccp((ptArray[x][y].x/wid)*texWid, (ptArray[x][y].y/hgt)*texHgt),
										   ccp((ptArray[x+1][y].x/wid)*texWid, (ptArray[x+1][y].y/hgt)*texHgt),
										   ccp((ptArray[x][y+1].x/wid)*texWid, (ptArray[x][y+1].y/hgt)*texHgt));

			//Triangle #2
			vdelta[numVertices] = ccp(randf(0.0, speedVar), randf(0.0, speedVar));
			adelta[numVertices] = randf(0.0, rotVar);
			colorArray[numVertices] = triColor4;						
			centerPt[numVertices] = ccp((x*pieceXsize)+(pieceXsize*0.7), (y*pieceYsize)+(pieceYsize*0.7)); 
			
			vertices[numVertices] = tri(ptArray[x+1][y], 
										ptArray[x+1][y+1], 
										ptArray[x][y+1]);
			texCoords[numVertices++] = tri(ccp((ptArray[x+1][y].x/wid)*texWid, (ptArray[x+1][y].y/hgt)*texHgt),
										   ccp((ptArray[x+1][y+1].x/wid)*texWid, (ptArray[x+1][y+1].y/hgt)*texHgt),
										   ccp((ptArray[x][y+1].x/wid)*texWid, (ptArray[x][y+1].y/hgt)*texHgt));			
		}
	}
}
@end
