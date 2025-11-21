#import <Foundation/Foundation.h>

@interface KBPredictionEngine : NSObject

@property (nonatomic, assign, readonly) BOOL isDictionaryReady;

+ (instancetype)sharedEngine;
- (void)loadData;
- (NSArray<NSString *> *)predictForWord:(NSString *)word;
- (NSArray<NSString *> *)predictionsForNextWord:(NSString *)word;

// New method to simulate download
- (void)downloadDictionaryWithCompletion:(void(^)(BOOL success))completion;

@end
