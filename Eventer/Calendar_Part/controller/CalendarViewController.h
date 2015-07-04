//
//  CalendarViewController.h
//  Calendar
//
//  Created by emma on 15/5/14.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calendar.h"
#import "MenuRootViewController.h"
#import "ActivityItemViewController.h"

@interface CalendarViewController : MenuRootViewController<UIScrollViewDelegate, CalendarDataSource, CalendarDelegate>

//@property (weak,   nonatomic) IBOutlet Calendar *calendar;
//@property (weak,   nonatomic) IBOutlet UILabel *itemtitlelabel;

@property (nonatomic,strong)  Calendar *calendar;
@property (nonatomic,strong)  UILabel *itemtitleLabel;


@property (assign, nonatomic) NSInteger      theme;
@property (assign, nonatomic) CalendarFlow   flow;
@property (assign, nonatomic) BOOL           lunar;
@property (copy,   nonatomic) NSDate         *selectedDate;
@property (assign, nonatomic) NSUInteger     firstWeekday;


@property (nonatomic, retain) ActivityItemViewController *activityItemVC;
@property (strong, nonatomic) NSDate *currentDate;

- (void)backToCurrentMonth:(id)sender;

@end
