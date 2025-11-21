#import "FullAccessGuideViewController.h"

@interface FullAccessGuideViewController ()
@end

@implementation FullAccessGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self setupUI];
}

- (void)setupUI {
    // ScrollView for content
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scrollView];
    
    // Container
    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:contentView];
    
    // Icon
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"lock.shield"]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.tintColor = [UIColor systemBlueColor];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:iconView];
    
    // Title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Enable Full Access";
    titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:titleLabel];
    
    // Description
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"Full Access allows the keyboard to read theme settings, user preferences, and enable emoji and prediction features. We do NOT collect or store what you type.\n\nLongvek Keyboard needs 'Full Access' to provide:\n• Smart Predictions\n• Themes & Customization\n• Haptic Feedback";
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = [UIColor secondaryLabelColor];
    descLabel.font = [UIFont systemFontOfSize:16];
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:descLabel];
    
    // Instructions Box
    UIView *instructionBox = [[UIView alloc] init];
    instructionBox.backgroundColor = [UIColor secondarySystemBackgroundColor];
    instructionBox.layer.cornerRadius = 12;
    instructionBox.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:instructionBox];
    
    UILabel *stepsLabel = [[UILabel alloc] init];
    stepsLabel.text = @"1. Tap 'Go to Settings' below\n2. Tap 'Keyboards'\n3. Select 'LongvekKeyboard'\n4. Toggle 'Allow Full Access' ON";
    stepsLabel.numberOfLines = 0;
    stepsLabel.font = [UIFont monospacedSystemFontOfSize:15 weight:UIFontWeightRegular];
    stepsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [instructionBox addSubview:stepsLabel];
    
    // Action Button
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [settingsButton setTitle:@"Go to Settings" forState:UIControlStateNormal];
    settingsButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    settingsButton.backgroundColor = [UIColor systemBlueColor];
    [settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settingsButton.layer.cornerRadius = 25;
    settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [settingsButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:settingsButton];
    
    // Constraints
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [contentView.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor],
        
        [iconView.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:40],
        [iconView.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [iconView.widthAnchor constraintEqualToConstant:80],
        [iconView.heightAnchor constraintEqualToConstant:80],
        
        [titleLabel.topAnchor constraintEqualToAnchor:iconView.bottomAnchor constant:20],
        [titleLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        [descLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:16],
        [descLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:30],
        [descLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-30],
        
        [instructionBox.topAnchor constraintEqualToAnchor:descLabel.bottomAnchor constant:30],
        [instructionBox.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20],
        [instructionBox.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20],
        
        [stepsLabel.topAnchor constraintEqualToAnchor:instructionBox.topAnchor constant:20],
        [stepsLabel.leadingAnchor constraintEqualToAnchor:instructionBox.leadingAnchor constant:20],
        [stepsLabel.trailingAnchor constraintEqualToAnchor:instructionBox.trailingAnchor constant:-20],
        [stepsLabel.bottomAnchor constraintEqualToAnchor:instructionBox.bottomAnchor constant:-20],
        
        [settingsButton.topAnchor constraintEqualToAnchor:instructionBox.bottomAnchor constant:40],
        [settingsButton.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [settingsButton.widthAnchor constraintEqualToConstant:200],
        [settingsButton.heightAnchor constraintEqualToConstant:50],
        [settingsButton.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-40]
    ]];
}

- (void)openSettings {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

@end
