//
//  KBThemeManager.h
//  IBoardAI
//
//  Created by Cascade on 21/11/25.
//

#import <UIKit/UIKit.h>

@interface KBThemeManager : NSObject

@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, strong, readonly) UIColor *keyColor;
@property (nonatomic, strong, readonly) UIColor *specialKeyColor;
@property (nonatomic, strong, readonly) UIColor *keyTextColor;
@property (nonatomic, strong, readonly) UIColor *popupColor;
@property (nonatomic, strong, readonly) UIColor *predictionBarColor;
@property (nonatomic, strong, readonly) UIColor *shadowColor;
@property (nonatomic, strong, readonly) UIColor *borderColor;
@property (nonatomic, strong, readonly) UIColor *highlightedKeyColor;

+ (instancetype)sharedManager;
- (void)loadTheme:(NSString *)themeName;

@end
