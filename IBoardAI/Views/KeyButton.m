#import "KeyButton.h"
#import "KBThemeManager.h"

@interface KeyButton ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *secondaryLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation KeyButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    
    // Background View
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.userInteractionEnabled = NO;
    _backgroundView.layer.cornerRadius = 5.0; // Standard iOS is closer to 4.5 on iPhone, 8 on iPad? 
    // User requested 8.
    _backgroundView.layer.cornerRadius = 8.0;
    _backgroundView.layer.shadowOffset = CGSizeMake(0, 1.0);
    _backgroundView.layer.shadowRadius = 0.0;
    _backgroundView.layer.shadowOpacity = 0.35;
    _backgroundView.layer.borderWidth = 0.5; // Thin border
    // _backgroundView.hidden = YES; // Comment out bg button as requested
    [self addSubview:_backgroundView];
    
    // Icon View
    _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.userInteractionEnabled = NO;
    [self addSubview:_iconView];
    
    // Top Label (Primary Character)
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"KhmerDigital-Regular" size:14]; // Reduced font size
    if (!_titleLabel.font) {
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    }
    _titleLabel.userInteractionEnabled = NO;
    [self addSubview:_titleLabel];
    
    // Bottom Label (Secondary/Shifted Character)
    _secondaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _secondaryLabel.textAlignment = NSTextAlignmentCenter;
    // Use system font to ensure size is respected if custom font behaves oddly
    _secondaryLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    _secondaryLabel.alpha = 0.6; // Slightly clearer distinction
    _secondaryLabel.userInteractionEnabled = NO;
    [self addSubview:_secondaryLabel];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeDown];
    
    [self updateTheme];
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gesture {
    if (self.secondaryTitle && self.secondaryTitle.length > 0 && self.onSwipeDown) {
        self.onSwipeDown(self.secondaryTitle);
        
        // Visual feedback
        UIView *feedbackView = [[UIView alloc] initWithFrame:self.bounds];
        feedbackView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        feedbackView.layer.cornerRadius = 5.0;
        [self addSubview:feedbackView];
        
        [UIView animateWithDuration:0.2 animations:^{
            feedbackView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [feedbackView removeFromSuperview];
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _backgroundView.frame = CGRectInset(self.bounds, 3, 5); // Tighter native spacing
    
    if (self.icon) {
        // Center icon
        CGFloat iconSize = MIN(self.bounds.size.width, self.bounds.size.height) * 0.45;
        _iconView.frame = CGRectMake((self.bounds.size.width - iconSize)/2, (self.bounds.size.height - iconSize)/2, iconSize, iconSize);
        _titleLabel.hidden = YES;
        _secondaryLabel.hidden = YES;
        _iconView.hidden = NO;
    } else {
        _titleLabel.hidden = NO;
        _iconView.hidden = YES;
        
        if (self.secondaryTitle && self.secondaryTitle.length > 0) {
            // Dual Label Layout - Top Big, Bottom Small - Centered and Closer
            _secondaryLabel.hidden = NO;
            
            CGFloat height = self.bounds.size.height;
            CGFloat padding = 3;
            CGFloat usableHeight = height - (padding * 3);
            
            // Define heights to ensure overlap/tightness
            CGFloat topH = usableHeight * 0.45;
            CGFloat bottomH = usableHeight * 0.45; // Overlap logic
            
            // Calculate Center Y
            CGFloat centerY = height / 2.0;
            
            // Position Top Label so its bottom edge is slightly below center
            // Position Bottom Label so its top edge is slightly above center
            // This creates the "closer" effect.
            
            // Top Label Frame
            // y = centerY - topH + overlapAmount
            // Let's just place them relative to center.
            
            _titleLabel.frame = CGRectMake(0, centerY - topH + 3, self.bounds.size.width, topH);
            
            // Bottom Label Frame
            // Moved up to centerY (was centerY + 2)
            _secondaryLabel.frame = CGRectMake(0, centerY, self.bounds.size.width, bottomH);
            
        } else {
            // Single Label Layout - Centered
            _secondaryLabel.hidden = YES;
            _titleLabel.frame = self.bounds; // Center in full bounds
        }
    }
}

- (void)setIsSpecialKey:(BOOL)isSpecialKey {
    _isSpecialKey = isSpecialKey;
    [self updateTheme];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    KBThemeManager *theme = [KBThemeManager sharedManager];
    UIColor *baseColor = self.isSpecialKey ? theme.specialKeyColor : theme.keyColor;
    
    if (highlighted) {
        _backgroundView.backgroundColor = theme.highlightedKeyColor;
    } else {
        _backgroundView.backgroundColor = baseColor;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if ([self isCombiningMark:title]) {
        _titleLabel.text = [@"\u25CC" stringByAppendingString:title];
    } else {
        _titleLabel.text = title;
    }
    _icon = nil; // Reset icon if title is set
    [self setNeedsLayout];
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    _iconView.image = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setNeedsLayout];
}

- (void)setSecondaryTitle:(NSString *)secondaryTitle {
    _secondaryTitle = secondaryTitle;
    if ([self isCombiningMark:secondaryTitle]) {
        _secondaryLabel.text = [@"\u25CC" stringByAppendingString:secondaryTitle];
    } else {
        _secondaryLabel.text = secondaryTitle;
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    _titleLabel.font = titleFont;
}

- (void)updateTheme {
    KBThemeManager *theme = [KBThemeManager sharedManager];
    _titleLabel.textColor = theme.keyTextColor;
    _secondaryLabel.textColor = [theme.keyTextColor colorWithAlphaComponent:0.7];
    _iconView.tintColor = theme.keyTextColor;
    
    UIColor *baseColor = self.isSpecialKey ? theme.specialKeyColor : theme.keyColor;
    _backgroundView.backgroundColor = baseColor;
    _backgroundView.layer.shadowColor = theme.shadowColor.CGColor;
    _backgroundView.layer.borderColor = theme.borderColor.CGColor;
}

- (BOOL)isCombiningMark:(NSString *)text {
    if (text.length == 0) return NO;
    unichar c = [text characterAtIndex:0];
    // Check for Khmer combining marks range
    // U+17B4 to U+17D3 (Vowels, Signs, Coeng)
    // U+17DD (Atthacan)
    // U+17C9 to U+17CA (Shift signs)
    return ((c >= 0x17B4 && c <= 0x17D3) || c == 0x17DD || (c >= 0x17C9 && c <= 0x17CA));
}

@end
