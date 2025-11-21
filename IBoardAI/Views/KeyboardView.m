#import "KeyboardView.h"
#import "KeyButton.h"
#import "KBThemeManager.h"

@interface KeyboardView ()
@property (nonatomic, strong) NSMutableArray<KeyButton *> *keyButtons;
@property (nonatomic, strong) KeyButton *deleteKey;
@property (nonatomic, strong) KeyButton *spaceKey;
@property (nonatomic, strong) KeyButton *returnKey;
@property (nonatomic, strong) KeyButton *shiftKey;
@property (nonatomic, strong) KeyButton *globeKey;
@property (nonatomic, strong) KeyButton *symbolKey; // 123 key
@property (nonatomic, assign) KBLayoutType currentLayout;
@property (nonatomic, assign) BOOL isShifted;
@end

@implementation KeyboardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.keyButtons = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        self.multipleTouchEnabled = YES; // Allow 2-finger swipes
    }
    return self;
}

- (void)setupWithLayout:(KBLayoutType)layoutType {
    self.currentLayout = layoutType;
    self.isShifted = NO;
    [self refreshKeys];
    [self setNeedsLayout];
}

- (void)refreshKeys {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.keyButtons removeAllObjects];
    
    // We need both Normal and Shifted keys to populate the Dual-Label keys
    NSArray<NSArray<NSString *> *> *normalKeys = [[KBLayoutManager sharedManager] keysForLayout:self.currentLayout];
    NSArray<NSArray<NSString *> *> *shiftedKeys = [[KBLayoutManager sharedManager] shiftedKeysForLayout:self.currentLayout];
    
    // Determine which set is "Active" for the main label based on isShifted state?
    // Actually, typical dual-label keyboards show:
    // Top: Normal Character
    // Bottom: Shifted/Secondary Character
    // When Shift is pressed, the input changes, but the labels might swap or just highlight.
    // Let's stick to: Top = Normal, Bottom = Shifted.
    // If isShifted is true, we might visually highlight the bottom label or swap them?
    // For now, let's just set them static: Title = Normal, Secondary = Shifted.
    
    NSArray<NSArray<NSString *> *> *activeKeys = self.isShifted ? shiftedKeys : normalKeys;

    // Create Character Keys
    for (int r = 0; r < normalKeys.count; r++) {
        NSArray *rowKeys = normalKeys[r];
        NSArray *rowShiftedKeys = (r < shiftedKeys.count) ? shiftedKeys[r] : nil;
        
        for (int k = 0; k < rowKeys.count; k++) {
            NSString *normalTitle = rowKeys[k];
            NSString *shiftedTitle = (rowShiftedKeys && k < rowShiftedKeys.count) ? rowShiftedKeys[k] : @"";
            
            KeyButton *key = [[KeyButton alloc] initWithFrame:CGRectZero];
            
            // Logic: Key Title is what is typed. Secondary is the other mode.
            // If Shifted: Title = Shifted Char, Secondary = Normal Char? 
            // Or simply: Title always shows what will be typed?
            // User request "UI it should how it like" -> Screenshot shows Top Big, Bottom Small.
            // Usually Top is the primary (Normal).
            
            if (self.isShifted) {
                key.title = shiftedTitle; // Typed
                key.secondaryTitle = normalTitle; // Decoration
            } else {
                key.title = normalTitle; // Typed
                key.secondaryTitle = shiftedTitle; // Decoration
            }

            [key addTarget:self action:@selector(handleKeyPress:) forControlEvents:UIControlEventTouchUpInside];
            
            // Add Long Press Gesture
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            longPress.minimumPressDuration = 0.3;
            [key addGestureRecognizer:longPress];
            
            // Handle Swipe Down for secondary character
            __weak typeof(self) weakSelf = self;
            key.onSwipeDown = ^(NSString *secondaryText) {
                [weakSelf.delegate keyPressed:secondaryText];
                [weakSelf updatePredictionsForText:secondaryText];
            };
            
            [self addSubview:key];
            [self.keyButtons addObject:key];
        }
    }
    
    [self setupFunctionalKeys];
    [self updateTheme];
}

- (void)setupFunctionalKeys {
    self.deleteKey = [[KeyButton alloc] initWithFrame:CGRectZero];
    self.deleteKey.icon = [UIImage systemImageNamed:@"delete.left"];
    self.deleteKey.isSpecialKey = YES;
    [self.deleteKey addTarget:self action:@selector(handleDelete) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteKey];
    
    self.spaceKey = [[KeyButton alloc] initWithFrame:CGRectZero];
    self.spaceKey.title = @"ខ្មែរ"; 
    [self.spaceKey addTarget:self action:@selector(handleSpace) forControlEvents:UIControlEventTouchUpInside];
    
    UISwipeGestureRecognizer *spaceSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpaceSwipeLeft)];
    spaceSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.spaceKey addGestureRecognizer:spaceSwipeLeft];
    
    UISwipeGestureRecognizer *spaceSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSpaceSwipeRight)];
    spaceSwipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.spaceKey addGestureRecognizer:spaceSwipeRight];
    
    [self addSubview:self.spaceKey];
    
    self.returnKey = [[KeyButton alloc] initWithFrame:CGRectZero];
    self.returnKey.icon = [UIImage systemImageNamed:@"return"];
    self.returnKey.isSpecialKey = YES;
    [self.returnKey addTarget:self action:@selector(handleReturn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.returnKey];
    
    self.shiftKey = [[KeyButton alloc] initWithFrame:CGRectZero];
    NSString *shiftIconName = self.isShifted ? @"arrow.up.circle.fill" : @"arrow.up";
    self.shiftKey.icon = [UIImage systemImageNamed:shiftIconName];
    self.shiftKey.isSpecialKey = YES;
    [self.shiftKey addTarget:self action:@selector(handleShift) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shiftKey];
    
    self.symbolKey = [[KeyButton alloc] initWithFrame:CGRectZero];
    self.symbolKey.title = (self.currentLayout == KBLayoutTypeSymbol) ? @"កខ" : @"១២"; 
    self.symbolKey.isSpecialKey = YES;
    [self.symbolKey addTarget:self action:@selector(handleSymbolToggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.symbolKey];
    
    self.globeKey = [[KeyButton alloc] initWithFrame:CGRectZero];
    if (self.currentLayout == KBLayoutTypeEmoji) {
        self.globeKey.icon = [UIImage systemImageNamed:@"keyboard"]; // Back to keyboard
    } else {
        self.globeKey.icon = [UIImage systemImageNamed:@"face.smiling"];
    }
    self.globeKey.isSpecialKey = YES;
    [self.globeKey addTarget:self action:@selector(handleEmojiToggle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.globeKey];
}

- (void)handleEmojiToggle {
    if (self.currentLayout == KBLayoutTypeEmoji) {
        self.currentLayout = KBLayoutTypeKhmer;
    } else {
        self.currentLayout = KBLayoutTypeEmoji;
    }
    [self refreshKeys];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat paddingX = 6.0; // Horizontal spacing
    CGFloat paddingY = 10.0; // Vertical spacing
    
    NSArray<NSArray<NSString *> *> *keysData = [[KBLayoutManager sharedManager] keysForLayout:self.currentLayout];
    NSInteger rowCount = keysData.count;
    
    CGFloat totalRows = rowCount + 1; // Rows + Footer
    CGFloat availableHeight = self.bounds.size.height - (paddingY * (totalRows + 1));
    CGFloat rowHeight = availableHeight / totalRows;
    
    // Calculate standard key width based on Row 1 (10 keys)
    // Width = (10 * std) + (11 * padding) -> 11 gaps including outer
    CGFloat availableWidthRow1 = self.bounds.size.width - (paddingX * 11);
    CGFloat standardKeyWidth = availableWidthRow1 / 10.0;
    
    int keyIndex = 0;
    CGFloat y = paddingY;
    
    for (int r = 0; r < rowCount; r++) {
        NSArray *rowKeys = keysData[r];
        NSInteger count = rowKeys.count;
        
        if (r == rowCount - 1) { // Row 3 (Last char row)
            // Row 3: Shift | Keys (7) | Delete
            // Calculate dynamic Action Key Width to fill row exactly
            // Total Width = (2 * Action) + (7 * Std) + (Padding * (1+1+6+1+1?))
            // Gaps: OuterL, Shift, Gap, K1..K7 (6 gaps), Gap, Del, OuterR. Total 10 gaps?
            // Layout: Pad | Shift | Pad | K1 | Pad ... | K7 | Pad | Del | Pad
            // Gaps = 1 + 1 + 6 + 1 + 1 = 10 gaps.
            
            CGFloat contentWidthOfKeys = (count * standardKeyWidth) + ((count - 1) * paddingX);
            CGFloat totalAvailable = self.bounds.size.width - (paddingX * 2); // remove outer
            CGFloat remaining = totalAvailable - contentWidthOfKeys - (paddingX * 2); // 2 gaps for shift/del
            CGFloat actionKeyWidth = remaining / 2.0;
            
            CGFloat x = paddingX;
            
            // Shift
            self.shiftKey.frame = CGRectMake(x, y, actionKeyWidth, rowHeight);
            x += actionKeyWidth + paddingX;
            
            // Character Keys
            for (int k = 0; k < count; k++) {
                if (keyIndex < self.keyButtons.count) {
                    KeyButton *btn = self.keyButtons[keyIndex];
                    btn.frame = CGRectMake(x, y, standardKeyWidth, rowHeight);
                    x += standardKeyWidth + paddingX;
                    keyIndex++;
                }
            }
            
            // Delete
            self.deleteKey.frame = CGRectMake(x, y, actionKeyWidth, rowHeight);
            
        } else {
            // Row 1 & 2: Center aligned standard keys
            // Row width
            CGFloat rowContentWidth = (count * standardKeyWidth) + ((count - 1) * paddingX);
            CGFloat x = (self.bounds.size.width - rowContentWidth) / 2.0;
            
            for (int k = 0; k < count; k++) {
                if (keyIndex < self.keyButtons.count) {
                    KeyButton *btn = self.keyButtons[keyIndex];
                    btn.frame = CGRectMake(x, y, standardKeyWidth, rowHeight);
                    x += standardKeyWidth + paddingX;
                    keyIndex++;
                }
            }
        }
        y += rowHeight + paddingY;
    }
    
    CGFloat bottomY = y;
    
    // Footer Layout: Symbol (123) | Globe (Emoji) | Space | Return
    // Symbol (123) & Return usually match Shift width or similar?
    // Let's use fixed ratios for footer to look like iOS.
    // 123: 1.3x, Globe: 1.0x, Return: 1.5x
    
    CGFloat symbolWidth = standardKeyWidth * 1.3;
    CGFloat globeWidth = standardKeyWidth;
    CGFloat returnWidth = standardKeyWidth * 1.5;
    
    CGFloat currentX = paddingX;
    
    // 1. Symbol (123)
    self.symbolKey.frame = CGRectMake(currentX, bottomY, symbolWidth, rowHeight);
    currentX += symbolWidth + paddingX;
    
    // 2. Globe (Emoji)
    self.globeKey.frame = CGRectMake(currentX, bottomY, globeWidth, rowHeight);
    currentX += globeWidth + paddingX;
    
    // Calculate Space Width
    // Right side: Return + Padding + OuterPadding
    CGFloat rightSideWidth = returnWidth + paddingX;
    CGFloat spaceWidth = self.bounds.size.width - currentX - rightSideWidth - paddingX; // Extra padding for margin
    
    // 3. Space
    self.spaceKey.frame = CGRectMake(currentX, bottomY, spaceWidth, rowHeight);
    currentX += spaceWidth + paddingX;
    
    // 4. Return
    self.returnKey.frame = CGRectMake(currentX, bottomY, returnWidth, rowHeight);
}

- (void)handleKeyPress:(KeyButton *)sender {
    [self.delegate keyPressed:sender.title];
    if (self.isShifted) {
        self.isShifted = NO;
        NSString *shiftIconName = @"arrow.up";
        self.shiftKey.icon = [UIImage systemImageNamed:shiftIconName];
        [self refreshKeys];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // Show popup
        // [self showPopupForKey:(KeyButton *)gesture.view];
        // For now, just insert the shifted character as a "long press alternative"
        // This is a shortcut to getting subscripts without shifting
        // Real implementation requires a popup view.
    }
}

- (void)handleSpaceSwipeLeft {
    // Switch language or move cursor
    [self.delegate globePressed]; // Cycle languages
}

- (void)handleSpaceSwipeRight {
    [self.delegate globePressed];
}

- (void)handleDelete { [self.delegate backspacePressed]; }
- (void)handleSpace { [self.delegate spacePressed]; }
- (void)handleReturn { [self.delegate returnPressed]; }

- (void)handleShift {
    self.isShifted = !self.isShifted;
    
    NSString *shiftIconName = self.isShifted ? @"arrow.up.circle.fill" : @"arrow.up";
    self.shiftKey.icon = [UIImage systemImageNamed:shiftIconName];
    
    [self refreshKeys];
}

- (void)updatePredictionsForText:(NSString *)text {
    // This is a helper to ensure predictions update even when bypass standard tap
    // Since logic is in VC, delegate keyPressed handles it, but we might need extra logic here if we wanted locally
    // Currently delegate keyPressed does [self updatePredictions], so this method is technically redundant 
    // BUT I added a call to it in the block above, so I must implement it to avoid crash.
    // Actually, the block calls [delegate keyPressed:] which updates predictions. 
    // So this method can be empty or just log.
}

- (void)handleGlobe { [self.delegate globePressed]; }

- (void)handleSymbolToggle {
    if (self.currentLayout == KBLayoutTypeSymbol) {
        self.currentLayout = KBLayoutTypeKhmer;
    } else {
        self.currentLayout = KBLayoutTypeSymbol;
    }
    [self refreshKeys];
}

- (void)updateTheme {
    self.backgroundColor = [KBThemeManager sharedManager].backgroundColor;
    for (KeyButton *btn in self.keyButtons) [btn updateTheme];
    [self.deleteKey updateTheme];
    [self.spaceKey updateTheme];
    [self.returnKey updateTheme];
    [self.shiftKey updateTheme];
    [self.globeKey updateTheme];
    [self.symbolKey updateTheme];
}

@end
