//
//  CalendarCell.h
//  Calendar
//
//  Created by emma on 15/6/13.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calendar.h"

@interface CalendarCell : UICollectionViewCell

@property (weak,   nonatomic) NSDictionary        *titleColors;
@property (weak,   nonatomic) NSDictionary        *subtitleColors;
@property (weak,   nonatomic) NSDictionary        *backgroundColors;

@property (weak,   nonatomic) UIColor             *eventColor;

@property (copy,   nonatomic) NSDate              *date;
@property (copy,   nonatomic) NSDate              *month;
@property (weak,   nonatomic) NSDate              *currentDate;

@property (copy,   nonatomic) NSString            *subtitle;

@property (weak,   nonatomic) UILabel             *titleLabel;
@property (weak,   nonatomic) UILabel             *subtitleLabel;

@property (assign, nonatomic) CalendarCellStyle cellStyle;
@property (assign, nonatomic) BOOL                hasEvent;

@property (readonly, getter = isPlaceholder)      BOOL placeholder;

- (void)showAnimation;
- (void)hideAnimation;
- (void)configureCell;

@end
