/* cocos2d for iPhone
 *
 * http://code.google.com/p/cocos2d-iphone
 *
 * Copyright (C) 2009 Matt Oswald
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */

#import <assert.h>
#import "AtlasSprite.h"
#import "AtlasSpriteManager.h"

const int defaultCapacity = 10;

/////////////////////////////////////////////////
/////////////////////////////////////////////////
@interface AtlasSprite (Remove)

-(void)setIndex:(int)index;
@end

@implementation AtlasSprite (Remove)

/////////////////////////////////////////////////
-(void)setIndex:(int)index
{
	mAtlasIndex = index;
	[self updateAtlas];
}

@end


/////////////////////////////////////////////////
/////////////////////////////////////////////////
@implementation AtlasSpriteManager

@synthesize atlas = mAtlas;

/////////////////////////////////////////////////
-(void)dealloc
{
	// "children"
	[mSprites makeObjectsPerformSelector:@selector(cleanup)];
	[mSprites release];
	
	[mAtlas release];

	[super dealloc];
}

/*
 * cocos2d scene management
 */
-(void) onEnter
{
	[super onEnter];
	for( AtlasSprite *s in mSprites)
		[s onEnter];
}

-(void) onExit
{
	for( AtlasSprite *s in mSprites)
		[s onExit];
	[super onExit];
}

/*
 * creation with Texture2D
 */
+(id)spriteManagerWithTexture:(Texture2D *)tex
{
	return [[[AtlasSpriteManager alloc] initWithTexture:tex capacity:defaultCapacity] autorelease];
}

+(id)spriteManagerWithTexture:(Texture2D *)tex capacity:(NSUInteger)capacity
{
	return [[[AtlasSpriteManager alloc] initWithTexture:tex capacity:capacity] autorelease];
}

/*
 * creation with File Image
 */
+(id)spriteManagerWithFile:(NSString*)fileImage capacity:(NSUInteger)capacity
{
	return [[[AtlasSpriteManager alloc] initWithFile:fileImage capacity:capacity] autorelease];
}

+(id)spriteManagerWithFile:(NSString*) imageFile
{
	return [[[AtlasSpriteManager alloc] initWithFile:imageFile capacity:defaultCapacity] autorelease];
}


/*
 * init with Texture2D
 */
-(id)initWithTexture:(Texture2D *)tex capacity:(NSUInteger)capacity
{
	if( (self=[super init])) {
		mTotalSprites = 0;
		mAtlas = [[TextureAtlas alloc] initWithTexture:tex capacity:capacity];
		mSprites = [[NSMutableArray alloc] initWithCapacity:capacity];
	}

	return self;
}

/*
 * init with FileImage
 */
-(id)initWithFile:(NSString *)fileImage capacity:(NSUInteger)capacity
{
	if( (self=[super init]) ) {
		mTotalSprites = 0;
		mAtlas = [[TextureAtlas alloc] initWithFile:fileImage capacity:capacity];
		mSprites = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	
	return self;
}


/////////////////////////////////////////////////
-(int)reserveIndexForSprite
{
	// if we're going beyond the current TextureAtlas's capacity,
	// all the previously initialized sprites will need to redo their texture coords
	// this is likely computationally expensive
	if(mTotalSprites == mAtlas.totalQuads)
	{
		CCLOG(@"Resizing TextureAtlas capacity, from [%d] to [%d].", mAtlas.totalQuads, mAtlas.totalQuads * 3 / 2);

		[mAtlas resizeCapacity:mAtlas.totalQuads * 3 / 2];
		
		for(AtlasSprite *sprite in mSprites)
		{
			[sprite updateAtlas];
		}
	}

	return mTotalSprites++;
}

/////////////////////////////////////////////////
-(AtlasSprite *)addSprite:(AtlasSprite *)newSprite
{
	[mSprites insertObject:newSprite atIndex:[newSprite atlasIndex]];
	
	if( isRunning )
		[newSprite onEnter];

	return newSprite;
}

/////////////////////////////////////////////////
-(void)removeSprite:(AtlasSprite *)sprite
{
	int index = [sprite atlasIndex];
	[mSprites removeObjectAtIndex:index];
	--mTotalSprites;

	// update all sprites beyond this one
	int count = [mSprites count];
	for(; index != count; ++index)
	{
		AtlasSprite *other = (AtlasSprite *)[mSprites objectAtIndex:index];
		NSAssert([other atlasIndex] == index + 1, @"AtlasSpriteManager: index failed");
		[other setIndex:index];
	}
	
	if( isRunning )
		[sprite onExit];
}

/////////////////////////////////////////////////
-(void)removeSpriteAtIndex:(int)index
{
	[self removeSprite:(AtlasSprite *)[mSprites objectAtIndex:index]];
}

/////////////////////////////////////////////////
-(void)removeAllSprites
{
	for(AtlasSprite *sprite in mSprites)
	{
		if( isRunning )
			[sprite onExit];
	}

	[mSprites removeAllObjects];
	mTotalSprites = 0;
}

/////////////////////////////////////////////////
-(void)draw
{
	if(mTotalSprites > 0)
	{
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);

		glEnable(GL_TEXTURE_2D);

		[mAtlas drawNumberOfQuads:mTotalSprites];

		glDisable(GL_TEXTURE_2D);

		glDisableClientState(GL_VERTEX_ARRAY);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	}
}


/////////////////////////////////////////////////
-(int)numberOfSprites
{
	return [mSprites count];
}

/////////////////////////////////////////////////
-(AtlasSprite *)spriteAtIndex:(int)index
{
	return [mSprites objectAtIndex:index];
}

@end