//
//  POTimer.m
//  The Pomodoro
//
//  Created by Taylor Mott on 16.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "POTimer.h"



@interface POTimer()

@property (assign, nonatomic) BOOL isOn;
@property (strong, nonatomic) NSDate *expirationDate;

@end

@implementation POTimer

+ (POTimer *)sharedInstance {
    static POTimer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [POTimer new];
    });
    
    return sharedInstance;
}

-(void)startTimer
{
    self.isOn = YES;
    
    UILocalNotification *timerExpiredNotification = [UILocalNotification new];
    
    NSTimeInterval interval = self.minutes * 60 + self.seconds;
    self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    timerExpiredNotification.fireDate = self.expirationDate;
    timerExpiredNotification.timeZone = [NSTimeZone defaultTimeZone];
    timerExpiredNotification.soundName = UILocalNotificationDefaultSoundName;
    timerExpiredNotification.alertBody = @"Round Complete. Continue with next round?";
    timerExpiredNotification.alertAction = @"view";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:timerExpiredNotification];
    
    [self isActive];
}

-(void)cancelTimer
{
    self.isOn = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void)endTimer
{
    self.isOn = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:roundCompleteNotification object:nil];
}

-(void)decreaseSecond
{
    if (self.seconds > 0)
    {
        self.seconds--;
        [[NSNotificationCenter defaultCenter] postNotificationName:secondTickNotification object:nil];
    }
    else if (self.seconds == 0 && self.minutes > 0)
    {
        self.minutes--;
        self.seconds = 59;
        [[NSNotificationCenter defaultCenter] postNotificationName:secondTickNotification object:nil];
    }
    else
    {
        [self endTimer];
    }
}

-(BOOL)isActive
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (self.isOn)
    {
        [self decreaseSecond];
        [self performSelector:@selector(isActive) withObject:nil afterDelay:1.0];
    }
    
    return self.isOn;
}

-(void)prepareForBackground
{
    [[NSUserDefaults standardUserDefaults] setObject:self.expirationDate forKey:expirationDate];
}

-(void)loadFromBackground
{
    self.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:expirationDate];
    NSTimeInterval seconds = [self.expirationDate timeIntervalSinceNow];
    self.minutes = seconds / 60;
    self.seconds = seconds - (self.minutes * 60);
}

@end
