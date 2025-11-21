#import <UIKit/UIKit.h>

@protocol GestureManagerDelegate <NSObject>
- (void)didSwipeLeft;
- (void)didSwipeRight;
- (void)didSwipeUp;
- (void)didSwipeDown;
@end

@interface GestureManager : NSObject

@property (nonatomic, weak) id<GestureManagerDelegate> delegate;

- (void)addGesturesToView:(UIView *)view;

@end
