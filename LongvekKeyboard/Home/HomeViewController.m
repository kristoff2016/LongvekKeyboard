#import "HomeViewController.h"
#import "HomeCardCell.h"
#import "HomeHeaderView.h"
#import "ThemeListViewController.h"
#import "SettingsViewController.h"
#import "TutorialPageViewController.h"
#import "FullAccessGuideViewController.h"

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    [self setupGradientBackground];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.gradientLayer.frame = self.view.bounds;
}

- (void)setupData {
    self.menuItems = @[
        @{@"title": @"Enable Keyboard", @"subtitle": @"Turn on in Settings", @"icon": @"keyboard", @"action": @"enableKeyboard"},
        @{@"title": @"Themes", @"subtitle": @"Customize your look", @"icon": @"paintbrush", @"action": @"showThemes"},
        @{@"title": @"Settings", @"subtitle": @"Predictions & more", @"icon": @"gear", @"action": @"showSettings"},
        @{@"title": @"Tutorial", @"subtitle": @"Learn gestures", @"icon": @"questionmark.circle", @"action": @"showTutorial"},
        @{@"title": @"Rate Us", @"subtitle": @"Support our team", @"icon": @"star.fill", @"action": @"rateApp"},
        @{@"title": @"About", @"subtitle": @"Version 1.0.0", @"icon": @"info.circle", @"action": @"showAbout"}
    ];
}

- (void)setupGradientBackground {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = @[
        (id)[UIColor systemBlueColor].CGColor,
        (id)[UIColor colorWithRed:0.4 green:0.0 blue:1.0 alpha:1.0].CGColor
    ];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)setupUI {
    self.navigationController.navigationBarHidden = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumLineSpacing = 16;
    layout.minimumInteritemSpacing = 16;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView registerClass:[HomeCardCell class] forCellWithReuseIdentifier:@"CardCell"];
    [self.collectionView registerClass:[HomeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    NSDictionary *item = self.menuItems[indexPath.row];
    [cell configureWithIcon:item[@"icon"] title:item[@"title"] subtitle:item[@"subtitle"]];
    
    // Initial Fade In
    cell.alpha = 0;
    [UIView animateWithDuration:0.5 delay:indexPath.row * 0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.alpha = 1;
    } completion:nil];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HomeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 250);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.frame.size.width - 40 - 16) / 2;
    return CGSizeMake(width, 160);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCardCell *cell = (HomeCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell animateTap];
    
    NSDictionary *item = self.menuItems[indexPath.row];
    NSString *action = item[@"action"];
    
    if ([action isEqualToString:@"enableKeyboard"]) {
        [self showEnableKeyboardGuide];
    } else if ([action isEqualToString:@"showThemes"]) {
        [self.navigationController pushViewController:[[ThemeListViewController alloc] init] animated:YES];
    } else if ([action isEqualToString:@"showSettings"]) {
        [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
    } else if ([action isEqualToString:@"showTutorial"]) {
        [self presentViewController:[[TutorialPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil] animated:YES completion:nil];
    } else if ([action isEqualToString:@"rateApp"]) {
        // Implement rating logic
    } else if ([action isEqualToString:@"showAbout"]) {
        [self showAboutAlert];
    }
}

#pragma mark - Actions

- (void)showEnableKeyboardGuide {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enable Full Access"
                                                                   message:@"To get the best prediction experience:\n\n1. Go to Settings\n2. Tap Keyboards\n3. Enable Longvek Keyboard\n4. Toggle 'Allow Full Access' ON"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAboutAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"About"
                                                                   message:@"Longvek Keyboard v1.0\nBuilt with Objective-C"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
