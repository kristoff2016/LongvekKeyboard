#import <Foundation/Foundation.h>
#import "Constants.h"

@interface AppGroupManager : NSObject

+ (instancetype)sharedManager;
- (NSUserDefaults *)userDefaults;
- (void)saveTheme:(NSString *)themeName;
- (NSString *)currentTheme;
- (void)setPredictionsEnabled:(BOOL)enabled;
- (BOOL)arePredictionsEnabled;

@end
