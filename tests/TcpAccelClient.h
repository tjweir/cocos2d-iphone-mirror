#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "VirtualAccelerometer.h"

@class Sprite;

//CLASS INTERFACE
@interface AppController : NSObject <UIAlertViewDelegate, UITextFieldDelegate>
{
}
@end

@interface SpriteDemo : Layer
{
	Sprite * grossini;
}
-(void) centerSprites;
-(NSString*) title;
@end

@interface SpriteMove : SpriteDemo <UIAccelerometerDelegate>

@end
