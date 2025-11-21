#import "ThemeListViewController.h"
#import "ThemeManager.h"
#import "AppGroupManager.h"

@interface ThemeListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *themes;
@end

@implementation ThemeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select Theme";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.themes = [ThemeManager availableThemes];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSDictionary *theme = self.themes[indexPath.row];
    cell.textLabel.text = theme[@"name"];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    colorView.backgroundColor = theme[@"color"];
    colorView.layer.cornerRadius = 12;
    cell.accessoryView = colorView;
    
    NSString *currentTheme = [[AppGroupManager sharedManager] currentTheme];
    if ([currentTheme isEqualToString:theme[@"name"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *theme = self.themes[indexPath.row];
    [[AppGroupManager sharedManager] saveTheme:theme[@"name"]];
    [tableView reloadData];
}

@end
