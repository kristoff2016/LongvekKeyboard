#import <UIKit/UIKit.h>

@interface KeyButton : UIControl

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *secondaryTitle;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) BOOL isSpecialKey;
@property (nonatomic, strong) UIFont *titleFont;

// The actual text to insert when pressed (if different from title)
@property (nonatomic, copy) NSString *outputValue;

@property (nonatomic, copy) void (^onSwipeDown)(NSString *secondaryText);

- (void)updateTheme;

@end
