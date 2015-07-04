//
//  CalendarMenu.h
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

#import "CalendarMenuItem.h"
#import "CalendarMenuItemView.h"
#import "CalendarMenuContainerView.h"

@class CalendarMenu;
@class CalendarMenuItem;

typedef NS_ENUM(NSInteger, CalendarMenuImageAlignment) {
    CalendarMenuImageAlignmentLeft,
    CalendarMenuImageAlignmentRight
};

typedef NS_ENUM(NSInteger, CalendarMenuLiveBackgroundStyle) {
    CalendarMenuLiveBackgroundStyleLight,
    CalendarMenuLiveBackgroundStyleDark
};

#ifndef CalendarUIKitIsFlatModeFunction
#define CalendarUIKitIsFlatModeFunction
BOOL CalendarUIKitIsFlatMode();
#endif

@protocol CalendarMenuDelegate <NSObject>
@optional
-(void)willOpenMenu:(CalendarMenu *)menu;
-(void)didOpenMenu:(CalendarMenu *)menu;
-(void)willCloseMenu:(CalendarMenu *)menu;
-(void)didCloseMenu:(CalendarMenu *)menu;

@end

@interface CalendarMenu : NSObject
// Data
//
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) UIView *backgroundView;
@property (assign, readonly, nonatomic) BOOL isOpen;
@property (assign, readonly, nonatomic) BOOL isAnimating;
@property (assign, nonatomic) BOOL waitUntilAnimationIsComplete;
@property (copy, nonatomic) void (^closeCompletionHandler)(void);
@property (copy, readwrite, nonatomic) void (^closePreparationBlock)(void);
@property (assign, nonatomic) BOOL closeOnSelection;
@property (weak, nonatomic) id <CalendarMenuDelegate> delegate;

// Style
//
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic) UIColor *shadowColor;
@property (assign, nonatomic) CGSize shadowOffset;
@property (assign, nonatomic) CGFloat shadowOpacity;
@property (assign, nonatomic) CGFloat shadowRadius;
@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) CGFloat itemWidth;

@property (assign, nonatomic) CGFloat backgroundAlpha;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *separatorColor;
@property (assign, nonatomic) CGFloat separatorHeight;
@property (assign, nonatomic) CGSize separatorOffset;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *textShadowColor;
@property (assign, nonatomic) CGSize textOffset;
@property (assign, nonatomic) CGSize textShadowOffset;
@property (assign, nonatomic) CalendarMenuImageAlignment imageAlignment;

@property (strong, nonatomic) UIColor *highlightedBackgroundColor;
@property (strong, nonatomic) UIColor *highlightedSeparatorColor;
@property (strong, nonatomic) UIColor *highlightedTextColor;
@property (strong, nonatomic) UIColor *highlightedTextShadowColor;
//@property (strong, nonatomic) UIColor *highlightedImageTintColor;
@property (assign, nonatomic) CGSize highlightedTextShadowOffset;
@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (assign, nonatomic) NSTimeInterval animationDuration;
@property (assign, nonatomic) NSTimeInterval closeAnimationDuration;
@property (assign, nonatomic) NSTimeInterval bounceAnimationDuration;
@property (assign, nonatomic) BOOL appearsBehindNavigationBar;
@property (assign, nonatomic) BOOL bounce;
@property (assign, nonatomic) BOOL liveBlur; // Available only in iOS 7
@property (strong, nonatomic) UIColor *liveBlurTintColor; // Available only in iOS 7
@property (assign, nonatomic) CalendarMenuLiveBackgroundStyle liveBlurBackgroundStyle; //


- (id)initWithItems:(NSArray *)items;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view;
- (void)showInView:(UIView *)view;
- (void)showFromNavigationController:(UINavigationController *)navigationController;
- (void)setNeedsLayout;
- (void)closeWithCompletion:(void (^)(void))completion;
- (void)close;


@end




