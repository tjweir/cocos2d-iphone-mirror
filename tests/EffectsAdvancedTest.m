//
// Advanced Effects Demo
// a cocos2d example
// http://code.google.com/p/cocos2d-iphone
//

// cocos2d import
#import "cocos2d.h"

// local import
#import "EffectsAdvancedTest.h"

enum {
	kTagTextLayer = 1,

	kTagSprite1 = 1,
	kTagSprite2 = 2,

	kTagBackground = 1,
	kTagLabel = 2,
};

#pragma mark - Classes

@interface Effect1 : TextLayer
{}
@end

@implementation Effect1
-(void) onEnter
{
	[super onEnter];
	
	id target = [self getByTag:kTagBackground];
	
	// To reuse a grid the grid size and the grid type must be the same.
	// in this case:
	//     Lens3D is Grid3D and it's size is (15,10)
	//     Waves3D is Grid3D and it's size is (15,10)
	id lens = [Lens3D actionWithPosition:cpv(240,160) radius:240 grid:ccg(15,10) duration:0.0f];
	id waves = [Waves3D actionWithWaves:18 amplitude:80 grid:ccg(15,10) duration:10];

	id reuse = [ReuseGrid actionWithTimes:1];
	id delay = [DelayTime actionWithDuration:8];

	id orbit = [OrbitCamera actionWithDuration:5 radius:1 deltaRadius:2 angleZ:0 deltaAngleZ:180 angleX:0 deltaAngleX:-90];
	id orbit_back = [orbit reverse];

	[target do: [RepeatForever actionWithAction: [Sequence actions: orbit, orbit_back, nil]]];
	[target do: [Sequence actions: lens, delay, reuse, waves, nil]];
}
-(NSString*) title
{
	return @"Lens + Waves3d and OrbitCamera";
}
@end

@interface Effect2 : TextLayer
{}
@end

@implementation Effect2
-(void) onEnter
{
	[super onEnter];
	
	id target = [self getByTag:kTagBackground];
	
	// To reuse a grid the grid size and the grid type must be the same.
	// in this case:
	//     ShakyTiles3D is TiledGrid3D and it's size is (15,10)
	//     Shuffletiles is TiledGrid3D and it's size is (15,10)
	//	   TurnOfftiles is TiledGrid3D and it's size is (15,10)
	id shaky = [ShakyTiles3D actionWithRange:4 grid:ccg(15,10) duration:5];
	id shuffle = [ShuffleTiles actionWithSeed:0 grid:ccg(15,10) duration:3];
	id turnoff = [TurnOffTiles actionWithSeed:0 grid:ccg(15,10) duration:3];
	id turnon = [turnoff reverse];
	
	// reuse 2 times:
	//   1 for shuffle
	//   2 for turn off
	//   turnon tiles will use a new grid
	id reuse = [ReuseGrid actionWithTimes:2];

	id delay = [DelayTime actionWithDuration:1];
	
//	id orbit = [OrbitCamera actionWithDuration:5 radius:1 deltaRadius:2 angleZ:0 deltaAngleZ:180 angleX:0 deltaAngleX:-90];
//	id orbit_back = [orbit reverse];
//
//	[target do: [RepeatForever actionWithAction: [Sequence actions: orbit, orbit_back, nil]]];
	[target do: [Sequence actions: shaky, delay, reuse, shuffle, [[delay copy] autorelease], turnoff, turnon, nil]];
}
-(NSString*) title
{
	return @"ShakyTiles + ShuffleTiles + TurnOffTiles";
}
@end

@interface Effect3 : TextLayer
{}
@end

@implementation Effect3
-(void) onEnter
{
	[super onEnter];
	
	id bg = [self getByTag:kTagBackground];
	id target1 = [bg getByTag:kTagSprite1];
	id target2 = [bg getByTag:kTagSprite2];
	
	
	id waves = [Waves actionWithWaves:5 amplitude:20 horizontal:YES vertical:NO grid:ccg(15,10) duration:5];
	id shaky = [Shaky3D actionWithRange:4 grid:ccg(15,10) duration:5];
	
	[target1 do: [RepeatForever actionWithAction: waves]];
	[target2 do: [RepeatForever actionWithAction: shaky]];
	
}
-(NSString*) title
{
	return @"Effects on 2 sprites";
}
@end


#pragma mark Demo - order

static int actionIdx=-1;
static NSString *actionList[] =
{
	@"Effect3",
	@"Effect1",
	@"Effect2",
};

Class nextAction()
{	
	actionIdx++;
	actionIdx = actionIdx % ( sizeof(actionList) / sizeof(actionList[0]) );
	NSString *r = actionList[actionIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class backAction()
{
	actionIdx--;
	int total = ( sizeof(actionList) / sizeof(actionList[0]) );
	if( actionIdx < 0 )
		actionIdx += total;
	NSString *r = actionList[actionIdx];
	Class c = NSClassFromString(r);
	return c;
}

Class restartAction()
{
	NSString *r = actionList[actionIdx];
	Class c = NSClassFromString(r);
	return c;
}

@implementation TextLayer
-(id) init
{
	if( (self = [super init]) ) {
	
		float x,y;
		
		CGSize size = [[Director sharedDirector] winSize];
		x = size.width;
		y = size.height;
		
		Sprite *bg = [Sprite spriteWithFile:@"background.png"];
		[self add: bg z:0 tag:kTagBackground];
		bg.transformAnchor = cpvzero;
//		bg.position = cpv(x/2,y/2);
		
		Sprite *grossini = [Sprite spriteWithFile:@"grossinis_sister2.png"];
		[bg add:grossini z:1 tag:kTagSprite1];
		grossini.position = cpv(x/3.0f,200);
		id sc = [ScaleBy actionWithDuration:2 scale:5];
		id sc_back = [sc reverse];
	
		[grossini do: [RepeatForever actionWithAction: [Sequence actions:sc, sc_back, nil]]];

		Sprite *tamara = [Sprite spriteWithFile:@"grossinis_sister1.png"];
		[bg add:tamara z:1 tag:kTagSprite2];
		tamara.position = cpv(2*x/3.0f,200);
		id sc2 = [ScaleBy actionWithDuration:2 scale:5];
		id sc2_back = [sc2 reverse];
		[tamara do: [RepeatForever actionWithAction: [Sequence actions:sc2, sc2_back, nil]]];
		
		
		Label* label = [Label labelWithString:[self title] fontName:@"Marker Felt" fontSize:32];
		
		[label setPosition: cpv(x/2,y-80)];
		[self add: label];
		label.tag = kTagLabel;
		
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

	}
	
	return self;
}

-(NSString*) title
{
	return @"No title";
}

-(void) restartCallback: (id) sender
{
	Scene *s = [Scene node];
	[s add: [restartAction() node]];
	[[Director sharedDirector] replaceScene: s];
}

-(void) nextCallback: (id) sender
{
	Scene *s = [Scene node];
	[s add: [nextAction() node]];
	[[Director sharedDirector] replaceScene: s];
}

-(void) backCallback: (id) sender
{
	Scene *s = [Scene node];
	[s add: [backAction() node]];
	[[Director sharedDirector] replaceScene: s];
}

- (void) dealloc
{
	[super dealloc];
}

@end

// CLASS IMPLEMENTATIONS
@implementation AppController

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:NO];
	
	// must be called before any othe call to the director
	[Director useFastDirector];
	
	// Use this pixel format to have transparent buffers
	[[Director sharedDirector] setPixelFormat:kRGBA8];

	// It seems that Orbit + 3d Effects needs DepthBuffer
	// But this breaks other FBO examples. Any idea ?
	// XXX: Help needed
//	[[Director sharedDirector] setDepthBufferFormat:kDepthBuffer24];
	
	// before creating any layer, set the landscape mode
	[[Director sharedDirector] setLandscape: YES];
	[[Director sharedDirector] setAnimationInterval:1.0/60];
	[[Director sharedDirector] setDisplayFPS:YES];
	
	// create an openGL view inside a window
	[[Director sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];	
	
	Scene *scene = [Scene node];
	[scene add: [nextAction() node]];	
	
	[[Director sharedDirector] runWithScene: scene];
}

- (void) dealloc
{
	[window dealloc];
	[super dealloc];
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

// purge memroy
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[Director sharedDirector] setNextDeltaTimeZero:YES];
}

@end
