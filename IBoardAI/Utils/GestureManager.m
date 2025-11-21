#import "GestureManager.h"

@implementation GestureManager

- (void)addGesturesToView:(UIView *)view {
    view.multipleTouchEnabled = YES; // Ensure view can receive 2-finger touches
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:right];
    
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    up.direction = UISwipeGestureRecognizerDirectionUp;
    up.numberOfTouchesRequired = 2; // 2 finger swipe for layout toggle
    up.delaysTouchesBegan = YES;
    [view addGestureRecognizer:up];
    
    UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    down.direction = UISwipeGestureRecognizerDirectionDown;
    down.numberOfTouchesRequired = 2;
    down.delaysTouchesBegan = YES;
    [view addGestureRecognizer:down];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.delegate didSwipeLeft];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.delegate didSwipeRight];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        [self.delegate didSwipeUp];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        [self.delegate didSwipeDown];
    }
}

@end
