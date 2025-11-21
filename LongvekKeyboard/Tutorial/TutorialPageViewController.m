#import "TutorialPageViewController.h"

@interface TutorialContentViewController : UIViewController
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *text;
@end

@implementation TutorialContentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = self.text;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:label];
}
@end

@interface TutorialPageViewController () <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSArray *pageTexts;
@end

@implementation TutorialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.pageTexts = @[@"Welcome to Longvek Keyboard", @"Swipe to type faster", @"Customize your themes"];
    
    TutorialContentViewController *initialVC = [self viewControllerAtIndex:0];
    [self setViewControllers:@[initialVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (index >= self.pageTexts.count) return nil;
    TutorialContentViewController *vc = [[TutorialContentViewController alloc] init];
    vc.index = index;
    vc.text = self.pageTexts[index];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((TutorialContentViewController *)viewController).index;
    if (index == 0 || index == NSNotFound) return nil;
    return [self viewControllerAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((TutorialContentViewController *)viewController).index;
    if (index == NSNotFound || index == self.pageTexts.count - 1) return nil;
    return [self viewControllerAtIndex:index + 1];
}

@end
