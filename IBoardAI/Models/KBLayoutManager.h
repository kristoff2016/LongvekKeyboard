#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KBLayoutType) {
    KBLayoutTypeKhmer,      // 4-row standard
    KBLayoutTypeKhmer5Row,  // 5-row extended
    KBLayoutTypeSymbol,
    KBLayoutTypeEmoji
};

@interface KBLayoutManager : NSObject

@property (nonatomic, assign) KBLayoutType currentLayoutType;

+ (instancetype)sharedManager;
- (NSArray<NSArray<NSString *> *> *)keysForLayout:(KBLayoutType)type;
- (NSArray<NSArray<NSString *> *> *)shiftedKeysForLayout:(KBLayoutType)type;
- (NSArray<NSArray<NSString *> *> *)numberRow; // For 5-row

@end
