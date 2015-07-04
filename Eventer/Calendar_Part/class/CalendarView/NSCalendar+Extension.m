//
//  NSCalendar+Extension.m
//  Calendar
//
//  Created by emma on 15/6/13.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "NSCalendar+Extension.h"

@implementation NSCalendar (Extension)

+ (instancetype)_sharedCalendar
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSCalendar currentCalendar];
    });
    return instance;
}

@end
