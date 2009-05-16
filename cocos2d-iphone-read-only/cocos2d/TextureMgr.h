/* cocos2d for iPhone
 *
 * http://code.google.com/p/cocos2d-iphone
 *
 * Copyright (C) 2008,2009 Ricardo Quesada
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

/** Singleton that handles the loading of textures
 * Once the texture is loaded, the next time it will return
 * a reference of the previously loaded texture reducing GPU & CPU memory
 */
@interface TextureMgr : NSObject
{
	NSMutableDictionary *textures;
}

/** Retruns ths shared instance of the Texture Manager */
+ (TextureMgr *) sharedTextureMgr;

/** Returns a Texture2D object given an file image
 * If the file image was not previously loaded, it will create a new Texture2D
 *  object and it will return it.
 * Otherwise it will return a reference of a previosly loaded image.
 * Supported images extensions: .png, .bmp, .tiff, .jpeg, .pvr
 */
-(Texture2D*) addImage: (NSString*) fileimage;

/** Returns a Texture2D object given an PVRTC RAW filename
 * If the file image was not previously loaded, it will create a new Texture2D
 *  object and it will return it. Otherwise it will return a reference of a previosly loaded image
 *
 * It can only load square images: width == height, and it must be a power of 2 (128,256,512...)
 * bpp can only be 2 or 4. 2 means more compression but lower quality.
 * hasAlpha: whether or not the image contains alpha channel
 */
-(Texture2D*) addPVRTCImage: (NSString*) fileimage bpp:(int)bpp hasAlpha:(BOOL)alpha width:(int)w;

/** Returns a Texture2D object given an PVRTC filename
 * If the file image was not previously loaded, it will create a new Texture2D
 *  object and it will return it. Otherwise it will return a reference of a previosly loaded image
 */
-(Texture2D*) addPVRTCImage: (NSString*) filename;


/** Returns a Texture2D object given an CGImageRef image
 * If the image was not previously loaded, it will create a new Texture2D
 *  object and it will return it.
 * Otherwise it will return a reference of a previosly loaded image
 */
-(Texture2D*) addCGImage: (CGImageRef) image;

/** Purges the dictionary of loaded textures.
 * Call this method if you receive the "Memory Warning"
 * In the short term: it will free some resources preventing your app from being killed
 * In the medium term: it will allocate more resources
 * In the long term: it will be the same
 */
-(void) removeAllTextures;

/** Removes unused textures
 * Textures that have a retain count of 1 will be deleted
 * It is convinient to call this method after when starting a new Scene
 * @since v0.8
 */
-(void) removeUnusedTextures;

/** Deletes a texture from the Texture Manager
 */
-(void) removeTexture: (Texture2D*) tex;
@end
