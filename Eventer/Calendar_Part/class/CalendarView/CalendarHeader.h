//
//  CalendarHeader.h
//  Calendar
//
//  Created by emma on 15/6/13.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarHeader, Calendar;

@interface CalendarHeader : UIView

@property (assign, nonatomic) CGFloat                         minDissolveAlpha;
@property (assign, nonatomic) CGFloat                         scrollOffset;
@property (copy,   nonatomic) NSString                        *dateFormat;

@property (weak,   nonatomic) UIColor                         *titleColor;
@property (weak,   nonatomic) UIFont                          *titleFont;

@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;

- (void)reloadData;

@end
