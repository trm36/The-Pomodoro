//
//  PORoundsViewController.m
//  The Pomodoro
//
//  Created by Taylor Mott on 9.23.14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "PORoundsViewController.h"
#import "PORoundsDataSource.h"
#import "POTimerViewController.h"
#import "TRMTimer.h"

NSString * const SET_TIMER = @"set timer";

@interface PORoundsViewController () <UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) PORoundsDataSource *dataSource;

@end

@implementation PORoundsViewController

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"The Pomodoro";
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
    
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.dataSource = [PORoundsDataSource new];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self registerForNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [self unregisterForNotifications];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dataSource.currentRound = indexPath.row;
    [self setTimerWithCurrentRound];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newRound" object:nil];
}

#pragma mark - notification methods

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToNextRound) name:@"timerComplete" object:nil];
}

- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"timerComplete" object:nil];
}

- (void)goToNextRound
{
    self.dataSource.currentRound++;
    if (self.dataSource.currentRound < [self.dataSource roundsArray].count)
    {
        NSLog(@"%ld", (long)self.dataSource.currentRound);
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataSource.currentRound inSection:0];
        NSLog(@"%@", indexPath);
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self setTimerWithCurrentRound];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextRoundReady" object:nil];
    }
}

#pragma mark - timer methods

- (void) setTimerWithCurrentRound
{
    NSNumber *timerLength = [self.dataSource roundsArray][self.dataSource.currentRound];
    [[TRMTimer sharedInstance] setTimer:[timerLength longValue]];
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
