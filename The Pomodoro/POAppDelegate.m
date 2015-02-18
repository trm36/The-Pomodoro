//
//  POAppDelegate.m
//  The Pomodoro
//
//  Created by Joshua Howland on 6/3/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "POAppDelegate.h"
#import "RoundsViewController.h"
#import "TimerViewController.h"
#import "POTimer.h"

@implementation POAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    TimerViewController *timerVC = [TimerViewController new];
    timerVC.tabBarItem.title = @"Timer";
    timerVC.tabBarItem.image = [UIImage imageNamed:@"timer.png"];
    
    RoundsViewController *roundsVC = [RoundsViewController new];
    UINavigationController *roundsNavController = [[UINavigationController alloc] initWithRootViewController:roundsVC];
    roundsNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Rounds" image:[UIImage imageNamed:@"tomato.png"] tag:1];
    
    
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[timerVC, roundsNavController];
    
    self.window.rootViewController = tabBarController;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Round Finished!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Start Next Round" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[POTimer sharedInstance] startTimer];
    }]];
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    [[POTimer sharedInstance] prepareForBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[POTimer sharedInstance] loadFromBackground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
