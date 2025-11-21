#import "HomeHeaderView.h"

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // Logo
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _logoImageView.image = [UIImage systemImageNamed:@"keyboard"]; // Placeholder
    _logoImageView.tintColor = [UIColor whiteColor];
    _logoImageView.layer.cornerRadius = 30;
    _logoImageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_logoImageView];
    
    // Title
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"Khmer Smart Keyboard";
    _titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_titleLabel];
    
    // Subtitle
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.text = @"Fast. Smart. Beautiful.";
    _subtitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _subtitleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_subtitleLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [_logoImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:20],
        [_logoImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_logoImageView.widthAnchor constraintEqualToConstant:80],
        [_logoImageView.heightAnchor constraintEqualToConstant:80],
        
        [_titleLabel.topAnchor constraintEqualToAnchor:_logoImageView.bottomAnchor constant:16],
        [_titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [_titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        
        [_subtitleLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:8],
        [_subtitleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [_subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        [_subtitleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20]
    ]];
}

@end
