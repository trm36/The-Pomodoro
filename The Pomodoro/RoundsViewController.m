//
//  RoundsViewController.m
//  The Pomodoro
//
//  Created by Taylor Mott on 16.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "RoundsViewController.h"
#import "POTimer.h"

static NSString *reuseID = @"reuseID";

@interface RoundsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger currentRound;

@end

@implementation RoundsViewController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self registerForNotifications];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Round Times";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID];
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods

-(NSArray *)roundTimes
{
    return @[@25, @5, @25, @5, @25, @5, @25, @15];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ minutes", [self roundTimes][indexPath.row]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self roundTimes].count;
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentRound = indexPath.row;
    [self roundSelected];
    [[POTimer sharedInstance] cancelTimer];
}

#pragma mark - Notifications Methods

-(void)roundSelected
{
    [POTimer sharedInstance].minutes = [[self roundTimes][self.currentRound] integerValue];
    [POTimer sharedInstance].seconds = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:currentRoundNotification object:nil];
}

-(void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roundComplete) name:roundCompleteNotification object:nil];
}

-(void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)roundComplete
{
    if (self.currentRound < [self roundTimes].count - 1)
    {
        self.currentRound++;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRound inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self roundSelected];
    }
    else
    {
        self.currentRound = 0;
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRound inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self roundSelected];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
