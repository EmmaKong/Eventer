//
//  NSDate+Extension.m
//  Calendar
//
//  Created by emma on 15/6/13.
//  Copyright (c) 2015年 Emma. All rights reserved.
//


#import "NSDate+Extension.h"
#import "NSCalendar+Extension.h"

@implementation NSDate (FSExtension)

- (NSInteger)_year
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitYear fromDate:self];
    return component.year;
}

- (NSInteger)_month
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitMonth
                                              fromDate:self];
    return component.month;
}

- (NSInteger)_day
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay
                                              fromDate:self];
    return component.day;
}

- (NSInteger)_weekday
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return component.weekday;
}

- (NSInteger)_hour
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitHour
                                              fromDate:self];
    return component.hour;
}

- (NSInteger)_minute
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitMinute
                                              fromDate:self];
    return component.minute;
}

- (NSInteger)_second
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitSecond
                                              fromDate:self];
    return component.second;
}

- (NSInteger)_numberOfDaysInMonth
{
    NSCalendar *c = [NSCalendar _sharedCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:self];
    return days.length;
}

- (NSString *)_stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSDate *)_dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)_dateBySubtractingMonths:(NSInteger)months
{
    return [self _dateByAddingMonths:-months];
}

- (NSDate *)_dateByAddingDays:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)_dateBySubtractingDays:(NSInteger)days
{
    return [self _dateByAddingDays:-days];
}

- (NSInteger)_yearsFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    return components.year;
}

- (NSInteger)_monthsFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    return components.month;
}

- (NSInteger)_daysFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    return components.day;
}

- (BOOL)_isEqualToDateForMonth:(NSDate *)date
{
    return self._year == date._year && self._month == date._month;
}

- (BOOL)_isEqualToDateForDay:(NSDate *)date
{
    return self._year == date._year && self._month == date._month && self._day == date._day;
}


+ (instancetype)_dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

+ (instancetype)_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar _sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return [calendar dateFromComponents:components];
}

@end

