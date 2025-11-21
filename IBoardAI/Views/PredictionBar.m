#import "PredictionBar.h"
#import "KBThemeManager.h"

@interface PredictionBar ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) NSMutableArray<UIView *> *separators;
@property (nonatomic, strong) UIVisualEffectView *backgroundView;

// Download Prompt UI
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@end

@implementation PredictionBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.buttons = [NSMutableArray array];
        self.separators = [NSMutableArray array];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    // 1. Background Blur
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.backgroundView];
    
    // 2. Scroll View (Predictions)
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceHorizontal = YES; // Allow bounce even if content fits
    [self addSubview:self.scrollView];
    
    [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    // 3. Stack View
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.distribution = UIStackViewDistributionFill; // Allow buttons to have intrinsic width
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.spacing = 0; // Spacing handled by separator views
    [self.scrollView addSubview:self.stackView];
    
    // StackView Constraints
    [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor].active = YES;
    [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor].active = YES;
    [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor].active = YES;
    
    [self.stackView.heightAnchor constraintEqualToAnchor:self.scrollView.heightAnchor].active = YES;
    
    NSLayoutConstraint *minWidth = [self.stackView.widthAnchor constraintGreaterThanOrEqualToAnchor:self.widthAnchor];
    minWidth.priority = UILayoutPriorityDefaultLow; // Allow growing
    minWidth.active = YES;
    
    // 4. Create Buttons & Separators
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        // Add padding to button content
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.stackView addArrangedSubview:btn];
        [self.buttons addObject:btn];
        
        // Make buttons TRY to be at least 1/3 of screen width
        [btn.widthAnchor constraintGreaterThanOrEqualToAnchor:self.widthAnchor multiplier:0.33].active = YES;
        
        // Also ensure min width based on content is respected (handled by intrinsic content size automatically)
        // But we need to ensure they expand to fill if total is less than screen.
        // UIStackView distribution 'Fill' will leave empty space at end if not constrained.
        // We can add a spacer view at the end? Or set distribution to FillEqually?
        // If we set FillEqually, they can't grow beyond their share without breaking.
        
        // Better approach:
        // Use UIStackViewDistributionFill.
        // Give each button a width constraint >= 1/3 screen.
        // This ensures they fill the screen.
        // If text is long, intrinsic size > constraint, so it grows.
        
        if (i < 2) {
            UIView *separatorContainer = [[UIView alloc] init];
            [separatorContainer.widthAnchor constraintEqualToConstant:1].active = YES;
            
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
            line.translatesAutoresizingMaskIntoConstraints = NO;
            [separatorContainer addSubview:line];
            
            [line.centerXAnchor constraintEqualToAnchor:separatorContainer.centerXAnchor].active = YES;
            [line.centerYAnchor constraintEqualToAnchor:separatorContainer.centerYAnchor].active = YES;
            [line.widthAnchor constraintEqualToConstant:1].active = YES;
            [line.heightAnchor constraintEqualToConstant:20].active = YES;
            
            [self.stackView addArrangedSubview:separatorContainer];
        }
    }
    
    // 5. Download Button (Hidden by default)
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.downloadButton.frame = self.bounds;
    self.downloadButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.downloadButton setTitle:@"ចុចទីនេះដើម្បីទាញយកពាក្យព្យាករណ៍" forState:UIControlStateNormal];
    self.downloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.downloadButton addTarget:self action:@selector(downloadTapped) forControlEvents:UIControlEventTouchUpInside];
    self.downloadButton.hidden = YES;
    [self addSubview:self.downloadButton];
    
    // 6. Loading Indicator (Hidden by default)
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingIndicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.loadingIndicator];
    
    [self updateTheme];
}

- (void)showDownloadPrompt {
    self.scrollView.hidden = YES;
    self.downloadButton.hidden = NO;
    self.loadingIndicator.hidden = YES;
}

- (void)showLoading {
    self.scrollView.hidden = YES;
    self.downloadButton.hidden = YES;
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
}

- (void)setPredictions:(NSArray<NSString *> *)predictions {
    // Ensure download mode is off
    self.scrollView.hidden = NO;
    self.downloadButton.hidden = YES;
    self.loadingIndicator.hidden = YES;
    [self.loadingIndicator stopAnimating];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = self.buttons[i];
        if (i < predictions.count) {
            NSString *pred = predictions[i];
            // Add quotes or style if needed? No, plain text is best.
            [btn setTitle:pred forState:UIControlStateNormal];
            btn.hidden = NO;
            btn.alpha = 1.0;
        } else {
            btn.hidden = YES;
        }
    }
}

- (void)downloadTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapDownloadDictionary)]) {
        [self.delegate didTapDownloadDictionary];
    }
}

- (void)buttonTapped:(UIButton *)sender {
    // Add a small scale animation
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            sender.transform = CGAffineTransformIdentity;
        }];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPrediction:)]) {
        [self.delegate didSelectPrediction:sender.currentTitle];
    }
}

- (void)updateTheme {
    // Update Blur Style based on theme?
    // For now, just update text colors.
    UIColor *textColor = [KBThemeManager sharedManager].keyTextColor;
    
    for (UIButton *btn in self.buttons) {
        [btn setTitleColor:textColor forState:UIControlStateNormal];
    }
    
    [self.downloadButton setTitleColor:textColor forState:UIControlStateNormal];
    self.loadingIndicator.color = textColor;
    
    // If using dark mode, update blur
    // self.backgroundView.effect = ...
}

@end
