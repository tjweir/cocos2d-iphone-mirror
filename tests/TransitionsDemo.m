//
// Transitions Demo
// a cocos2d example
//

// local import
#import "cocos2d.h"
#import "TransitionsDemo.h"

@interface FlipXLeftOver : FlipXTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface FlipXRightOver : FlipXTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface FlipYUpOver : FlipYTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface FlipYDownOver : FlipYTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface FlipAngularLeftOver : FlipAngularTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface FlipAngularRightOver : FlipAngularTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface ZoomFlipXLeftOver : ZoomFlipXTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface ZoomFlipXRightOver : ZoomFlipXTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface ZoomFlipYUpOver : ZoomFlipYTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface ZoomFlipYDownOver : ZoomFlipYTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface ZoomFlipAngularLeftOver : ZoomFlipAngularTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end
@interface ZoomFlipAngularRightOver : ZoomFlipAngularTransition 
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s;
@end

@implementation FlipXLeftOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationLeftOver];
}
@end
@implementation FlipXRightOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationRightOver];
}
@end
@implementation FlipYUpOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationUpOver];
}
@end
@implementation FlipYDownOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationDownOver];
}
@end
@implementation FlipAngularLeftOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationLeftOver];
}
@end
@implementation FlipAngularRightOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationRightOver];
}
@end
@implementation ZoomFlipXLeftOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationLeftOver];
}
@end
@implementation ZoomFlipXRightOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationRightOver];
}
@end
@implementation ZoomFlipYUpOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationUpOver];
}
@end
@implementation ZoomFlipYDownOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationDownOver];
}
@end
@implementation ZoomFlipAngularLeftOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationLeftOver];
}
@end
@implementation ZoomFlipAngularRightOver
+(id) transitionWithDuration:(ccTime) t scene:(Scene*)s {
	return [self transitionWithDuration:t scene:s orientation:kOrientationRightOver];
}
@end



static int sceneIdx=0;
static NSString *transitions[] = {
						 @"FadeTransition",
						 @"FlipXLeftOver",
						 @"FlipXRightOver",
						 @"FlipYUpOver",
						 @"FlipYDownOver",
						 @"FlipAngularLeftOver",
						 @"FlipAngularRightOver",
						 @"ZoomFlipXLeftOver",
						 @"ZoomFlipXRightOver",
						 @"ZoomFlipYUpOver",
						 @"ZoomFlipYDownOver",
						 @"ZoomFlipAngularLeftOver",
 						 @"ZoomFlipAngularRightOver",
						 @"ShrinkGrowTransition",
						 @"RotoZoomTransition",
						 @"JumpZoomTransition",
						 @"MoveInLTransition",
						 @"MoveInRTransition",
						 @"MoveInTTransition",
						 @"MoveInBTransition",
						 @"SlideInLTransition",
						 @"SlideInRTransition",
						 @"SlideInTTransition",
						 @"SlideInBTransition",
};

Class nextTransition()
{	
	// HACK: else NSClassFromString will fail
	[FadeTransition node];
	
	sceneIdx++;
	sceneIdx = sceneIdx % ( sizeof(transitions) / sizeof(transitions[0]) );
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class backTransition()
{
	// HACK: else NSClassFromString will fail
	[FadeTransition node];

	sceneIdx--;
	int total = ( sizeof(transitions) / sizeof(transitions[0]) );
	if( sceneIdx < 0 )
		sceneIdx += total;
	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class restartTransition()
{
	// HACK: else NSClassFromString will fail
	[FadeTransition node];

	NSString *r = transitions[sceneIdx];
	Class c = NSClassFromString(r);
	return c;
}

@implementation TextLayer
-(id) init
{
	if( ! [super initWithColor: 0x202020ff] )
		return nil;

	CGRect size;
	float x,y;
	
	size = [[Director sharedDirector] winSize];
	x = size.size.width;
	y = size.size.height;

	Label* label = [Label labelWithString:@"SCENE 1" dimensions:CGSizeMake(280, 64) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:64];

	[label setPosition: cpv(x/2,y/2)];	
	[self add: label];
	
	// menu
	MenuItemImage *item1 = [MenuItemImage itemFromNormalImage:@"b1.png" selectedImage:@"b2.png" target:self selector:@selector(backCallback:)];
	MenuItemImage *item2 = [MenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" target:self selector:@selector(restartCallback:)];
	MenuItemImage *item3 = [MenuItemImage itemFromNormalImage:@"f1.png" selectedImage:@"f2.png" target:self selector:@selector(nextCallback:)];
	Menu *menu = [Menu menuWithItems:item1, item2, item3, nil];
	menu.position = cpvzero;
	item1.position = cpv(480/2-100,30);
	item2.position = cpv(480/2, 30);
	item3.position = cpv(480/2+100,30);
	[self add: menu z:1];
	
	return self;
}

-(void) nextCallback:(id) sender
{
	Scene *s2 = [Scene node];
	[s2 add: [TextLayer2 node]];
	[[Director sharedDirector] replaceScene: [nextTransition() transitionWithDuration:1.2 scene:s2]];
}	

-(void) backCallback:(id) sender
{
	Scene *s2 = [Scene node];
	[s2 add: [TextLayer2 node]];
	[[Director sharedDirector] replaceScene: [backTransition() transitionWithDuration:1.2 scene:s2]];
}	

-(void) restartCallback:(id) sender
{
	Scene *s2 = [Scene node];
	[s2 add: [TextLayer2 node]];
	[[Director sharedDirector] replaceScene: [restartTransition() transitionWithDuration:1.2 scene:s2]];
}	
@end

@implementation TextLayer2
-(id) init
{
	if( ! [super initWithColor: 0xff0000ff] )
		return nil;
	
	isTouchEnabled = YES;
	
	CGRect size;
	float x,y;
	
	size = [[Director sharedDirector] winSize];
	x = size.size.width;
	y = size.size.height;
	
	Label* label = [Label labelWithString:@"SCENE 2" dimensions:CGSizeMake(280, 64) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:64];
	
	[label setPosition: cpv(x/2,y/2)];
	[self add: label];
	
	// menu
	MenuItemImage *item1 = [MenuItemImage itemFromNormalImage:@"b1.png" selectedImage:@"b2.png" target:self selector:@selector(backCallback:)];
	MenuItemImage *item2 = [MenuItemImage itemFromNormalImage:@"r1.png" selectedImage:@"r2.png" target:self selector:@selector(restartCallback:)];
	MenuItemImage *item3 = [MenuItemImage itemFromNormalImage:@"f1.png" selectedImage:@"f2.png" target:self selector:@selector(nextCallback:)];
	Menu *menu = [Menu menuWithItems:item1, item2, item3, nil];
	menu.position = cpvzero;
	item1.position = cpv(480/2-100,30);
	item2.position = cpv(480/2, 30);
	item3.position = cpv(480/2+100,30);
	[self add: menu z:1];
	
	return self;
}

-(void) nextCallback:(id) sender
{
	Scene *s2 = [Scene node];
	[s2 add: [TextLayer node]];
	[[Director sharedDirector] replaceScene: [nextTransition() transitionWithDuration:1.2 scene:s2]];
}	

-(void) backCallback:(id) sender
{
	Scene *s2 = [Scene node];
	[s2 add: [TextLayer node]];
	[[Director sharedDirector] replaceScene: [backTransition() transitionWithDuration:1.2 scene:s2]];
}	

-(void) restartCallback:(id) sender
{
	Scene *s2 = [Scene node];
	[s2 add: [TextLayer node]];
	[[Director sharedDirector] replaceScene: [restartTransition() transitionWithDuration:1.2 scene:s2]];
}	
@end

// CLASS IMPLEMENTATIONS
@implementation AppController

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// before creating any layer, set the landscape mode
	[[Director sharedDirector] setLandscape: YES];

	Scene *scene = [Scene node];
	[scene add: [TextLayer node]];
			 
	[[Director sharedDirector] runScene: scene];
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	[[Director sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[Director sharedDirector] resume];
}

@end
