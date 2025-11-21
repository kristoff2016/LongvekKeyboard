#import <UIKit/UIKit.h>
#import "KBLayoutManager.h"

@protocol KeyboardViewDelegate <NSObject>
- (void)keyPressed:(NSString *)key;
- (void)backspacePressed;
- (void)spacePressed;
- (void)returnPressed;
- (void)globePressed;
- (void)shiftPressed;
@end

@interface KeyboardView : UIView

@property (nonatomic, weak) id<KeyboardViewDelegate> delegate;

- (void)setupWithLayout:(KBLayoutType)layoutType;
- (void)updateTheme;

@end
