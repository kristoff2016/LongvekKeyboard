#import "AppGroupManager.h"

@implementation AppGroupManager

+ (instancetype)sharedManager {
    static AppGroupManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppGroupManager alloc] init];
    });
    return sharedInstance;
}

- (NSUserDefaults *)userDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:kAppGroupId];
}

- (void)saveTheme:(NSString *)themeName {
    [[self userDefaults] setObject:themeName forKey:kSelectedThemeKey];
    [[self userDefaults] synchronize];
}

- (NSString *)currentTheme {
    NSString *theme = [[self userDefaults] stringForKey:kSelectedThemeKey];
    return theme ? theme : @"Light"; // Default
}

- (void)setPredictionsEnabled:(BOOL)enabled {
    [[self userDefaults] setBool:enabled forKey:kPredictionsEnabledKey];
    [[self userDefaults] synchronize];
}

- (BOOL)arePredictionsEnabled {
    if ([[self userDefaults] objectForKey:kPredictionsEnabledKey] == nil) {
        return YES; // Default true
    }
    return [[self userDefaults] boolForKey:kPredictionsEnabledKey];
}

@end
