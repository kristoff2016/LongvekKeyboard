#import "ThemeManager.h"

@implementation ThemeManager

+ (NSArray<NSDictionary *> *)availableThemes {
    return @[
        @{@"name": @"Light", @"color": [UIColor whiteColor]},
        @{@"name": @"Dark", @"color": [UIColor blackColor]},
        @{@"name": @"Blue", @"color": [UIColor systemBlueColor]},
        @{@"name": @"Pink", @"color": [UIColor systemPinkColor]}
    ];
}

@end
