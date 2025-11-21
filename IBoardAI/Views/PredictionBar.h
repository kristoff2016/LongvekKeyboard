#import <UIKit/UIKit.h>

@protocol PredictionBarDelegate <NSObject>
- (void)didSelectPrediction:(NSString *)text;
@optional
- (void)didTapDownloadDictionary;
@end

@interface PredictionBar : UIView

@property (nonatomic, weak) id<PredictionBarDelegate> delegate;

- (void)setPredictions:(NSArray<NSString *> *)predictions;
- (void)showDownloadPrompt;
- (void)showLoading;
- (void)updateTheme;

@end
