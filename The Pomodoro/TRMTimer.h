//
//  TRMTimer.h
//  The Pomodoro
//
//  Created by Taylor Mott on 9.23.14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMTimer : NSObject

@property (nonatomic, readonly) NSInteger seconds;

+ (TRMTimer *)sharedInstance;

- (void)setTimer:(NSInteger)seconds;
- (void)startTimer;
- (void)stopTimer;
- (void)clearTimer;

@end
