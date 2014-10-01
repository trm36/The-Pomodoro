//
//  PORoundsDataSource.m
//  The Pomodoro
//
//  Created by Taylor Mott on 9.23.14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

#import "PORoundsDataSource.h"

static NSString *CELL = @"cell";
static NSInteger WORK_ROUND = 1500;  //in seconds 25 min * 60 sec/min = 1500;
static NSInteger SHORT_BREAK = 300;  //in seconds  5 min * 60 sec/min = 300;
static NSInteger LONG_BREAK = 900;   //in seconds 15 min * 60 sec/min = 900;

@implementation PORoundsDataSource

/*
 * REQUIRED METHOD OF TABLEVIEWDATASOURCE
 * Sets name of each table view cell
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL];
    }
    NSInteger roundNumber = indexPath.row + 1;
    NSInteger roundTimeInMinutes = [[self roundsArray][indexPath.row] integerValue] / 60;
    NSInteger remainingSeconds = [[self roundsArray][indexPath.row] integerValue] - roundTimeInMinutes * 60;
    
    cell.textLabel.text = [NSString stringWithFormat:@"Round %li", roundNumber];
    if (roundTimeInMinutes == 1)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%li minute", roundTimeInMinutes];
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%li minutes", roundTimeInMinutes];
    }
    if (remainingSeconds > 0)
    {
        if (remainingSeconds == 1)
        {
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:[NSString stringWithFormat:@", %li second", remainingSeconds]];
        }
        else
        {
            cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:[NSString stringWithFormat:@", %li seconds", remainingSeconds]];
        }
    }
    cell.detailTextLabel.textColor = [UIColor grayColor];
    UIFontDescriptor *fontDescriptor = [cell.detailTextLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    //Size 0 keeps size as is
    cell.detailTextLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:0];
    cell.detailTextLabel.numberOfLines = 1;
    
    return cell;
}

/*
 * REQUIRED METHOD OF TABLEVIEWDATASOURCE
 * sets the number of rows in the tableView
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self roundsArray] count];
}

- (NSArray *)roundsArray
{
    return @[[NSNumber numberWithLong:WORK_ROUND],
             [NSNumber numberWithLong:SHORT_BREAK],
             [NSNumber numberWithLong:WORK_ROUND],
             [NSNumber numberWithLong:SHORT_BREAK],
             [NSNumber numberWithLong:WORK_ROUND],
             [NSNumber numberWithLong:SHORT_BREAK],
             [NSNumber numberWithLong:WORK_ROUND],
             [NSNumber numberWithLong:LONG_BREAK]];
}

@end
