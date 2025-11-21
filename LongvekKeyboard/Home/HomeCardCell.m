#import "HomeCardCell.h"

@interface HomeCardCell ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation HomeCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // Container View (Card)
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = 20;
    _containerView.layer.masksToBounds = NO;
    
    // Shadow
    _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _containerView.layer.shadowOffset = CGSizeMake(0, 4);
    _containerView.layer.shadowRadius = 8;
    _containerView.layer.shadowOpacity = 0.1;
    
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_containerView];
    
    // Icon
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.tintColor = [UIColor systemBlueColor];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_iconImageView];
    
    // Title
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    _titleLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_titleLabel];
    
    // Subtitle
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    _subtitleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.numberOfLines = 2;
    _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_subtitleLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // Container
        [_containerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:4],
        [_containerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:4],
        [_containerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-4],
        [_containerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4],
        
        // Icon
        [_iconImageView.topAnchor constraintEqualToAnchor:_containerView.topAnchor constant:16],
        [_iconImageView.leadingAnchor constraintEqualToAnchor:_containerView.leadingAnchor constant:16],
        [_iconImageView.widthAnchor constraintEqualToConstant:32],
        [_iconImageView.heightAnchor constraintEqualToConstant:32],
        
        // Title
        [_titleLabel.topAnchor constraintEqualToAnchor:_iconImageView.bottomAnchor constant:12],
        [_titleLabel.leadingAnchor constraintEqualToAnchor:_containerView.leadingAnchor constant:16],
        [_titleLabel.trailingAnchor constraintEqualToAnchor:_containerView.trailingAnchor constant:-16],
        
        // Subtitle
        [_subtitleLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:4],
        [_subtitleLabel.leadingAnchor constraintEqualToAnchor:_containerView.leadingAnchor constant:16],
        [_subtitleLabel.trailingAnchor constraintEqualToAnchor:_containerView.trailingAnchor constant:-16],
        [_subtitleLabel.bottomAnchor constraintLessThanOrEqualToAnchor:_containerView.bottomAnchor constant:-16]
    ]];
}

- (void)configureWithIcon:(NSString *)iconName title:(NSString *)title subtitle:(NSString *)subtitle {
    self.iconImageView.image = [UIImage systemImageNamed:iconName];
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
}

- (void)animateTap {
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end
