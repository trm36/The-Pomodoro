//
//  POTimerViewController.m
//  The Pomodoro
//
//  Created by Taylor Mott on 9.23.14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "POTimerViewController.h"
#import "TRMTimer.h"
#import "PORoundsViewController.h"

static CGFloat const LABEL_SIZE = 125;
static CGFloat const BUTTON_SIZE = 50;
static CGFloat const TIMER_FONT_SIZE = 50;
static CGFloat const BUTTON_FONT_SIZE = 14;

@interface POTimerViewController ()

@property (strong, nonatomic) UILabel *timerDisplay;
@property (strong, nonatomic) UIButton *startTimerButton;

@end

@implementation POTimerViewController

- (POTimerViewController *)init
{
    self = [super init];
    if (self)
    {
        [self registerForNotifications];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterForNotifications];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat screenWidth = self.view.frame.size.width;
    
    self.timerDisplay = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - LABEL_SIZE)/2, 75, LABEL_SIZE, 100)];
    self.timerDisplay.textColor = [UIColor blueColor];
    self.timerDisplay.font = [UIFont systemFontOfSize:TIMER_FONT_SIZE];
    self.timerDisplay.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.timerDisplay];
    
    self.startTimerButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth - BUTTON_SIZE)/2, 175, BUTTON_SIZE, 25)];
    self.startTimerButton.enabled = NO;
    [self.startTimerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.startTimerButton setTitle:@"Start" forState:UIControlStateNormal];
    self.startTimerButton.titleLabel.font = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
    [self.startTimerButton addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startTimerButton];
    
    [self setTimerLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRound) name:@"newRound" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTimerLabel) name:@"secondTick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToNextRound) name:@"nextRoundReady" object:nil];
    
}

- (void)unregisterForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newRound" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"secondTick" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nextRoundReady" object:nil];
}

- (void)newRound
{
    [[TRMTimer sharedInstance] stopTimer];
    [self setTimerLabel];
}

- (void)setTimerLabel
{
    if ([TRMTimer sharedInstance].seconds)
    {
        [self enableButton];
    }
    [self updateTimerLabel];
}

- (void)updateTimerLabel
{
    NSUInteger minutes = [TRMTimer sharedInstance].seconds / 60;
    NSUInteger seconds = [TRMTimer sharedInstance].seconds - (minutes * 60);
    if (seconds < 10)
    {
        self.timerDisplay.text = [NSString stringWithFormat:@"%ld:0%ld", minutes, seconds];
    }
    else
    {
        self.timerDisplay.text = [NSString stringWithFormat:@"%ld:%ld", minutes, seconds];
    }
}

- (void)enableButton
{
    self.startTimerButton.enabled = YES;
    [self.startTimerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)startTimer
{
    [[TRMTimer sharedInstance] startTimer];
    self.startTimerButton.enabled = NO;
    [self.startTimerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)goToNextRound
{
    [self updateTimerLabel];
    [self startTimer];
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
