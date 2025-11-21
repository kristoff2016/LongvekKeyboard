#import "KeyboardViewController.h"
#import "KeyboardView.h"
#import "PredictionBar.h"
#import "KBPredictionEngine.h"
#import "KBThemeManager.h"
#import "GestureManager.h"
#import "KBLayoutManager.h"

@interface LongvekKeyboardViewController () <KeyboardViewDelegate, PredictionBarDelegate, GestureManagerDelegate>
@property (nonatomic, strong) KeyboardView *keyboardView;
@property (nonatomic, strong) PredictionBar *predictionBar;
@property (nonatomic, strong) GestureManager *gestureManager;
@end

@implementation LongvekKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. Setup Views First (so we can update them based on data state)
    [self setupViews];
    
    // 2. Check Dictionary Status
    if ([KBPredictionEngine sharedEngine].isDictionaryReady) {
        [[KBPredictionEngine sharedEngine] loadData];
    } else {
        // Show download prompt
        [self.predictionBar showDownloadPrompt];
    }
    
    // 3. Setup Gestures
    self.gestureManager = [[GestureManager alloc] init];
    self.gestureManager.delegate = self;
    [self.gestureManager addGesturesToView:self.view];
    
    // 4. Load Theme
    [self updateTheme];
}

- (void)setupViews {
    // Prediction Bar
    self.predictionBar = [[PredictionBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.predictionBar.delegate = self;
    self.predictionBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.predictionBar];
    
    // Keyboard View
    self.keyboardView = [[KeyboardView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 200)];
    self.keyboardView.delegate = self;
    self.keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.keyboardView setupWithLayout:KBLayoutTypeKhmer];
    [self.view addSubview:self.keyboardView];
    
    // Constraints
    [self.predictionBar.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.predictionBar.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.predictionBar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.predictionBar.heightAnchor constraintEqualToConstant:40].active = YES;
    
    [self.keyboardView.topAnchor constraintEqualToAnchor:self.predictionBar.bottomAnchor].active = YES;
    [self.keyboardView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.keyboardView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.keyboardView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    // Set explicit height for the keyboard extension view with priority to avoid conflicts
    NSLayoutConstraint *heightConstraint = [self.view.heightAnchor constraintEqualToConstant:300.0];
    heightConstraint.priority = UILayoutPriorityDefaultHigh; // Allow system to override if necessary
    heightConstraint.active = YES;
}

- (void)updateTheme {
    [[KBThemeManager sharedManager] loadTheme:@"Light"]; // Refactor to iOS Native Light theme
    self.view.backgroundColor = [KBThemeManager sharedManager].backgroundColor;
    [self.keyboardView updateTheme];
    [self.predictionBar updateTheme];
}

#pragma mark - KeyboardViewDelegate

- (void)keyPressed:(NSString *)key {
    [self.textDocumentProxy insertText:key];
    [self updatePredictions];
}

- (void)backspacePressed {
    [self.textDocumentProxy deleteBackward];
    [self updatePredictions];
}

- (void)spacePressed {
    [self.textDocumentProxy insertText:@" "];
}

- (void)returnPressed {
    [self.textDocumentProxy insertText:@"\n"];
}

- (void)shiftPressed {
    // Toggle shift state logic
}

- (void)globePressed {
    [self advanceToNextInputMode];
}

#pragma mark - Predictions

- (void)updatePredictions {
    // Simple implementation: get last word
    // Real implementation needs textDocumentProxy.documentContextBeforeInput analysis
    NSString *text = self.textDocumentProxy.documentContextBeforeInput;
    NSArray *words = [text componentsSeparatedByString:@" "];
    NSString *lastWord = words.lastObject;
    
    NSArray *predictions = [[KBPredictionEngine sharedEngine] predictForWord:lastWord];
    [self.predictionBar setPredictions:predictions];
}

- (void)didSelectPrediction:(NSString *)text {
    // Replace current word with prediction
    NSString *context = self.textDocumentProxy.documentContextBeforeInput;
    // Find the last word to replace
    // Simplified logic: assumes space delimiters. For Khmer (no spaces), complex logic is needed (tokenizer).
    // For now, we'll use the same logic as updatePredictions: last component separated by space.
    
    if (context) {
        NSArray *words = [context componentsSeparatedByString:@" "];
        NSString *lastWord = words.lastObject;
        
        // Delete the characters of the last word
        for (NSUInteger i = 0; i < lastWord.length; i++) {
            [self.textDocumentProxy deleteBackward];
        }
    }
    
    // Insert the prediction followed by a space?
    // Usually predictions include a space if it completes a word.
    // User request implies exact replacement. Let's add a space for convenience if it's a word.
    // But if "ស" -> "សួស្តី", we probably want "សួស្តី ".
    
    [self.textDocumentProxy insertText:text];
    // [self.textDocumentProxy insertText:@" "]; // Optional: auto-space
}

- (void)didTapDownloadDictionary {
    // Start download process
    [self.predictionBar showLoading];
    
    __weak typeof(self) weakSelf = self;
    [[KBPredictionEngine sharedEngine] downloadDictionaryWithCompletion:^(BOOL success) {
        if (success) {
            // Refresh predictions
            [weakSelf updatePredictions];
        }
    }];
}

#pragma mark - GestureManagerDelegate

- (void)didSwipeLeft {
    // Delete word
    [self backspacePressed];
}

- (void)didSwipeRight {
    // Swipe right action - English toggle disabled
}

- (void)didSwipeUp {
    // Toggle between 4-row and 5-row
    KBLayoutType current = [KBLayoutManager sharedManager].currentLayoutType;
    if (current == KBLayoutTypeKhmer) {
        [KBLayoutManager sharedManager].currentLayoutType = KBLayoutTypeKhmer5Row;
        [self.keyboardView setupWithLayout:KBLayoutTypeKhmer5Row];
    } else if (current == KBLayoutTypeKhmer5Row) {
        [KBLayoutManager sharedManager].currentLayoutType = KBLayoutTypeKhmer;
        [self.keyboardView setupWithLayout:KBLayoutTypeKhmer];
    }
}

- (void)didSwipeDown {
    // Same toggle logic for down swipe, or dismiss
    [self didSwipeUp]; 
}

@end
