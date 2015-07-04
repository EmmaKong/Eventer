//
//  DateUtils.m
//  Calendar
//
//  Created by emma on 15/5/7.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

//获取本周的日期数组
+ (NSArray *)getDatesOfCurrence
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2]; //1代表周日，2代表周一
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:now];
    // 得到周几
    NSInteger weekDay = [components weekday];
    // 得到几号
    NSInteger day = [components day];
    
    // 计算当前日期和这周的星期一差的天数
    long firstDiff;
    if (weekDay == 1) {
        firstDiff = 1-7;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
    }
    

    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    
    NSString *month = [NSString stringWithFormat:@"%ld",(long)[firstDayComp month]];

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:8];
    [array addObject:month];
    for (int i = 0; i< 7; i++) {
        [components setDay:[firstDayComp day] + i];
        [components setMonth:[month intValue]];
        NSDate *everyDate = [calendar dateFromComponents:components];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:everyDate];
        NSLog(@"%@",[NSString stringWithFormat:@"%ld%ld",(long)[components month],(long)[components day]]);
        [array addObject:[NSString stringWithFormat:@"%ld",(long)[components day]]];
    }
//    NSDateComponents*test=[[NSDateComponents alloc]init];
//    [test setDay:33];
//    [test setMonth:6];
//    NSDate*testdate=[calendar dateFromComponents:test];
//    test=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:testdate];
//    NSLog(@"testdate%@%@",[NSString stringWithFormat:@"%ld",(long)[test month]],[NSString stringWithFormat:@"%ld",(long)[test day]]);
    return array;
}

//获取距离当前多少周的日期数组
+ (NSArray *)getDatesSinceCurence:(int)weeks
{
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:weeks*7*24*60*60];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2]; //1代表周日，2代表周一
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:now];
    NSInteger weekDay = [components weekday];
    
    // 得到几号
    NSInteger day = [components day];
    NSLog(@"%dzhouyihou deshijian%ld%ld",weeks,(long)weekDay,(long)day);
    // 计算当前日期和这周的星期一和星期天差的天数
//    long firstDiff,lastDiff;
//    if (weekDay == 1) {
//        firstDiff = 1;
//        lastDiff = 7;
//    }else{
//        firstDiff = [calendar firstWeekday] - weekDay;
//        lastDiff = 8 - weekDay;
//    }
    long firstDiff;
    if (weekDay == 1) {
        firstDiff = 1-7;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
    }
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    
    NSString *month = [NSString stringWithFormat:@"%ld",(long)[firstDayComp month]];
    NSLog(@"month%@",month);
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:8];
    [array addObject:month];
    for (int i = 0; i< 7; i++) {
        [components setDay:[firstDayComp day] + i];
        [components setMonth:[month intValue]];
        NSDate *everyDate = [calendar dateFromComponents:components];
        NSDateComponents *everCom = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:everyDate];
        [array addObject:[NSString stringWithFormat:@"%ld",(long)[everCom day]]];
    }
    
    return array;
}


@end
