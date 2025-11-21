#import "KBThemeManager.h"

@interface KBThemeManager ()
@property (nonatomic, strong, readwrite) UIColor *backgroundColor;
@property (nonatomic, strong, readwrite) UIColor *keyColor;
@property (nonatomic, strong, readwrite) UIColor *specialKeyColor;
@property (nonatomic, strong, readwrite) UIColor *keyTextColor;
@property (nonatomic, strong, readwrite) UIColor *popupColor;
@property (nonatomic, strong, readwrite) UIColor *predictionBarColor;
@property (nonatomic, strong, readwrite) UIColor *shadowColor;
@property (nonatomic, strong, readwrite) UIColor *borderColor;
@property (nonatomic, strong, readwrite) UIColor *highlightedKeyColor;
@end

@implementation KBThemeManager

+ (instancetype)sharedManager {
    static KBThemeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KBThemeManager alloc] init];
        [sharedInstance loadTheme:@"Light"]; // Default
    });
    return sharedInstance;
}

- (void)loadTheme:(NSString *)themeName {
    if ([themeName isEqualToString:@"Dark"]) {
        // iOS Native Dark Theme
        self.backgroundColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:30/255.0 alpha:1.0];
        self.keyColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
        self.specialKeyColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0];
        self.keyTextColor = [UIColor whiteColor];
        self.popupColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0];
        self.predictionBarColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:30/255.0 alpha:1.0];
        self.shadowColor = [UIColor blackColor];
        self.borderColor = [UIColor clearColor];
        self.highlightedKeyColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        
    } else if ([themeName isEqualToString:@"Blue"]) {
        self.backgroundColor = [UIColor colorWithRed:0.85 green:0.9 blue:1.0 alpha:1.0];
        self.keyColor = [UIColor whiteColor];
        self.specialKeyColor = [UIColor colorWithRed:0.75 green:0.8 blue:0.9 alpha:1.0];
        self.keyTextColor = [UIColor systemBlueColor];
        self.popupColor = [UIColor whiteColor];
        self.predictionBarColor = [UIColor colorWithRed:0.9 green:0.95 blue:1.0 alpha:1.0];
        self.shadowColor = [UIColor colorWithRed:0.6 green:0.7 blue:0.8 alpha:1.0];
        self.borderColor = [UIColor clearColor];
        self.highlightedKeyColor = [UIColor colorWithRed:0.9 green:0.95 blue:1.0 alpha:1.0];
        
    } else if ([themeName isEqualToString:@"KhmerBlue"]) {
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:58.0/255.0 blue:138.0/255.0 alpha:1.0]; // #003a8a
        self.keyColor = [UIColor colorWithWhite:1.0 alpha:0.1]; // Semi-transparent
        self.specialKeyColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        self.keyTextColor = [UIColor whiteColor];
        self.popupColor = [UIColor colorWithRed:0.0/255.0 green:58.0/255.0 blue:138.0/255.0 alpha:1.0];
        self.predictionBarColor = [UIColor colorWithRed:0.0/255.0 green:50.0/255.0 blue:120.0/255.0 alpha:1.0];
        self.shadowColor = [UIColor clearColor]; 
        self.borderColor = [UIColor clearColor];
        self.highlightedKeyColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        
    } else { // Light - iOS Native Light (Updated to "Glassy Blue" per request)
        // Background: #003a8a (Khmer Blue)
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:58.0/255.0 blue:138.0/255.0 alpha:1.0];
        
        // Key: Glassy White (Matches background but lighter)
        self.keyColor = [UIColor colorWithWhite:1.0 alpha:0.15];
        
        // Special Key: Glassy Dark (Matches background but darker)
        self.specialKeyColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        
        // Text: White
        self.keyTextColor = [UIColor whiteColor];
        
        // Popup: Deep Blue
        self.popupColor = [UIColor colorWithRed:0.0/255.0 green:58.0/255.0 blue:138.0/255.0 alpha:1.0];
        
        // Prediction Bar: Match Background
        self.predictionBarColor = [UIColor colorWithRed:0.0/255.0 green:58.0/255.0 blue:138.0/255.0 alpha:1.0];
        
        // Shadow: Subtle dark shadow
        self.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.20];
        
        // Border: Subtle white border
        self.borderColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        
        // Highlighted: Brighter White Glass
        self.highlightedKeyColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    }
}

@end
