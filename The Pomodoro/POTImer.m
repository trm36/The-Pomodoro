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
    [self isActive];
}

-(void)cancelTimer
{
    self.isOn = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
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

@end
