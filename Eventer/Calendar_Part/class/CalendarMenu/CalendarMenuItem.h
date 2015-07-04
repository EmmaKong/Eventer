//
//  CalendarMenuItem.h
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CalendarMenuItemView.h"

@interface CalendarMenuItem : NSObject


@property (nonatomic, assign) UIColor *backgroundColor;
@property (nonatomic, assign) UIColor *separatorColor;
@property (nonatomic, assign) UIFont *font;
@property (nonatomic, assign) UIColor *textColor;
@property (nonatomic, assign) UIColor *textShadowColor;
@property (nonatomic, assign) CGSize textOffset;
@property (nonatomic, assign) CGSize textShadowOffset;
@property (nonatomic, assign) UIColor *highlightedBackgroundColor;
@property (nonatomic, assign) UIColor *highlightedSeparatorColor;
@property (nonatomic, assign) UIColor *highlightedTextColor;
@property (nonatomic, assign) UIColor *highlightedTextShadowColor;
@property (assign, nonatomic) CGSize highlightedTextShadowOffset;
@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (copy, nonatomic) NSString *title;

@property (copy, readwrite, nonatomic) void (^action)(CalendarMenuItem *item);
@property (assign, nonatomic) NSInteger tag;
@property (strong, nonatomic) UIView *customView;

- (id)initWithTitle:(NSString *)title action:(void (^)(CalendarMenuItem *item))action;
- (id)initWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor action:(void (^)(CalendarMenuItem *item))action;
- (id)initWithCustomView:(UIView *)customView action:(void (^)(CalendarMenuItem *item))action;
- (id)initWithCustomView:(UIView *)customView;
- (void)setNeedsLayout;


@end
