//
//  Calendar.h
//  Calendar
//
//  Created by emma on 15/6/13.
//  Copyright (c) 2015年 Emma. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CalendarHeader.h"

@class Calendar;

#ifndef IBInspectable
#define IBInspectable
#endif

typedef NS_ENUM(NSInteger, CalendarFlow) {
    CalendarFlowVertical ,
    CalendarFlowHorizontal
};

typedef NS_OPTIONS(NSInteger, CalendarCellStyle) {
    CalendarCellStyleCircle      = 0,
    CalendarCellStyleRectangle   = 1
};

typedef NS_OPTIONS(NSInteger, CalendarCellState) {
    CalendarCellStateNormal      = 0,
    CalendarCellStateSelected    = 1,
    CalendarCellStatePlaceholder = 1 << 1,
    CalendarCellStateDisabled    = 1 << 2,
    CalendarCellStateToday       = 1 << 3,
    CalendarCellStateWeekend     = 1 << 4
};

@protocol CalendarDelegate <NSObject>
@optional
- (BOOL)calendar:(Calendar *)calendar shouldSelectDate:(NSDate *)date;
- (void)calendar:(Calendar *)calendar didSelectDate:(NSDate *)date;
- (void)calendarCurrentMonthDidChange:(Calendar *)calendar;
@end


@protocol CalendarDataSource <NSObject>
@optional
- (NSString *)calendar:(Calendar *)calendar subtitleForDate:(NSDate *)date;
- (BOOL)calendar:(Calendar *)calendar hasEventForDate:(NSDate *)date;
@end

@interface Calendar : UIView<UIAppearance>
@property (strong,   nonatomic)  CalendarHeader     *header;
@property (assign, nonatomic) id<CalendarDelegate>   delegate;
@property (assign, nonatomic)  id<CalendarDataSource> dataSource;

@property (copy,   nonatomic) NSDate *currentDate;
@property (copy,   nonatomic) NSDate *selectedDate;
@property (copy,   nonatomic) NSDate *currentMonth;

@property (assign, nonatomic) CalendarFlow       flow;
@property (assign, nonatomic) IBInspectable NSUInteger           firstWeekday;
@property (assign, nonatomic) IBInspectable BOOL                 autoAdjustTitleSize;

@property (assign, nonatomic) IBInspectable CGFloat              minDissolvedAlpha UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) CalendarCellStyle cellStyle         UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIFont   *titleFont                UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIFont   *subtitleFont             UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIFont   *weekdayFont              UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *eventColor               UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *weekdayTextColor         UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIColor  *headerTitleColor         UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) NSString *headerDateFormat         UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIFont   *headerTitleFont          UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIColor  *titleDefaultColor        UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *titleSelectionColor      UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *titleTodayColor          UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *titlePlaceholderColor    UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *titleWeekendColor        UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIColor  *subtitleDefaultColor     UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *subtitleSelectionColor   UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *subtitleTodayColor       UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *subtitlePlaceholderColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *subtitleWeekendColor     UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIColor  *selectionColor           UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor  *todayColor               UI_APPEARANCE_SELECTOR;

- (void)reloadData;

@end



