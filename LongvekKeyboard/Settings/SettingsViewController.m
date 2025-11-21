#import "SettingsViewController.h"
#import "AppGroupManager.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Predictions";
        UISwitch *toggle = [[UISwitch alloc] init];
        toggle.on = [[AppGroupManager sharedManager] arePredictionsEnabled];
        [toggle addTarget:self action:@selector(togglePredictions:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = toggle;
    } else {
        cell.textLabel.text = @"Auto-Correct";
        UISwitch *toggle = [[UISwitch alloc] init];
        toggle.on = YES; // Default for now
        cell.accessoryView = toggle;
    }
    
    return cell;
}

- (void)togglePredictions:(UISwitch *)sender {
    [[AppGroupManager sharedManager] setPredictionsEnabled:sender.on];
}

@end
