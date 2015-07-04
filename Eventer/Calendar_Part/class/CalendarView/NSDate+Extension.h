//
//  NSDate+Extension.h
//  Calendar
//
//  Created by emma on 15/6/13.
//  Copyright (c) 2015年 Emma. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSDate (Extension)

@property (readonly, nonatomic) NSInteger _year;
@property (readonly, nonatomic) NSInteger _month;
@property (readonly, nonatomic) NSInteger _day;
@property (readonly, nonatomic) NSInteger _weekday;
@property (readonly, nonatomic) NSInteger _hour;
@property (readonly, nonatomic) NSInteger _minute;
@property (readonly, nonatomic) NSInteger _second;

@property (readonly, nonatomic) NSInteger _numberOfDaysInMonth;

- (NSDate *)_dateByAddingMonths:(NSInteger)months;
- (NSDate *)_dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)_dateByAddingDays:(NSInteger)days;
- (NSDate *)_dateBySubtractingDays:(NSInteger)days;
- (NSString *)_stringWithFormat:(NSString *)format;

- (NSInteger)_yearsFrom:(NSDate *)date;
- (NSInteger)_monthsFrom:(NSDate *)date;
- (NSInteger)_daysFrom:(NSDate *)date;

- (BOOL)_isEqualToDateForMonth:(NSDate *)date;
- (BOOL)_isEqualToDateForDay:(NSDate *)date;

+ (instancetype)_dateFromString:(NSString *)string format:(NSString *)format;
+ (instancetype)_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
