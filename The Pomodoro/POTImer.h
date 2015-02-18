//
//  POTimer.h
//  The Pomodoro
//
//  Created by Taylor Mott on 16.2.2015.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *secondTickNotification = @"secondTickNotification";
static NSString *roundCompleteNotification = @"roundCompleteNotification";
static NSString *currentRoundNotification = @"currentRoundNotification";
static NSString *expirationDate = @"expiryDate";

@interface POTimer : NSObject

@property (assign, nonatomic) NSInteger minutes;
@property (assign, nonatomic) NSInteger seconds;

+ (POTimer *)sharedInstance;
- (void)startTimer;
- (void)cancelTimer;
- (void)prepareForBackground;
- (void)loadFromBackground;

@end
