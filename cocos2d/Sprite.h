/* cocos2d for iPhone
 *
 * http://code.google.com/p/cocos2d-iphone
 *
 * Copyright (C) 2008 Ricardo Quesada
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */


#import <UIKit/UIKit.h>

#import "Support/Texture2D.h"

#import "TextureNode.h"

/** an Animation object used within Sprites to perform animations */
@interface Animation : NSObject
{
	NSString *name;
	float	delay;
	NSMutableArray *frames;
}

@property (readwrite,assign) NSString * name;
@property (readwrite,assign) float delay;
@property (readwrite,assign) NSMutableArray *frames;

/** creates an Animation with name, delay and frames */
+(id) animationWithName: (NSString*) name delay:(float)delay images:image1,... NS_REQUIRES_NIL_TERMINATION;
/** initializes an Animation with name, delay and frames */
-(id) initWithName: (NSString*) name delay:(float)delay firstImage:(NSString*)filename vaList:(va_list) args;
/** initializes an Animation with name and delay */
-(id) initWithName: (NSString*) name delay:(float)delay;
/** adds a frame to an Animation */
-(void) addFrame: (NSString*) filename;
@end


/** a 2D sprite */
@interface Sprite : TextureNode
{
	NSMutableDictionary *animations;	
}

/** creates an sprite with an image file */
+ (id) spriteWithFile:(NSString *)imageFile;
/** creates an sprite with a PVRTC image file
 * It can only load square images: width == height, and it must be a power of 2 (128,256,512...)
 * bpp can only be 2 or 4. 2 means more compression but lower quality.
 * hasAlpha: whether or not the image contains alpha channel
 */
+ (id) spriteWithPVRTCFile: (NSString*) fileimage bpp:(int)bpp hasAlpha:(BOOL)alpha width:(int)w;
/** creates an sprite from a CGImageRef image */
+ (id) spriteWithCGImage:(CGImageRef)image;

/** initializes the sprite with an image file */
- (id) initWithFile:(NSString *) imageFile;
/** creates an sprite with a PVRTC image file
 * It can only load square images: width == height, and it must be a power of 2 (128,256,512...)
 * bpp can only be 2 or 4. 2 means more compression but lower quality.
 * hasAlpha: whether or not the image contains alpha channel
 */
- (id) initWithPVRTCFile: (NSString*) fileimage bpp:(int)bpp hasAlpha:(BOOL)alpha width:(int)w;
/** creates an sprite from a CGImageRef image */
- (id) initWithCGImage:(CGImageRef)image;


/** adds an Animation to the Sprite */
-(void) addAnimation: (Animation*) animation;
/** changes the display frame based on an animation and an index */
-(void) setDisplayFrame: (NSString*) animationName index:(int) frameIndex;

@end
