//
//  CalendarMenu.m
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CalendarMenu.h"
#import "CalendarMenuItemView.h"

@interface CalendarMenuItem ()

@property (assign, readwrite, nonatomic) CalendarMenuItemView *itemView;

@end

@interface CalendarMenu ()

@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UIView *menuWrapperView;
@property (strong, nonatomic) CalendarMenuContainerView *containerView;
@property (strong, nonatomic) UIButton *backgroundButton;
@property (assign, nonatomic) BOOL isOpen;
@property (assign, nonatomic) BOOL isAnimating;
@property (strong, nonatomic) NSMutableArray *itemViews;
@property (weak, nonatomic) UINavigationBar *navigationBar;
@property (strong, nonatomic) UIToolbar *toolbar;

@end

@implementation CalendarMenu

BOOL CalendarUIKitIsFlatMode()
{
    static BOOL isUIKitFlatMode = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (floor(NSFoundationVersionNumber) > 993.0) {
            // If your app is running in legacy mode, tintColor will be nil - else it must be set to some color.
            if (UIApplication.sharedApplication.keyWindow) {
                isUIKitFlatMode = [UIApplication.sharedApplication.delegate.window respondsToSelector:@selector(tintColor)];
            } else {
                // Possible that we're called early on (e.g. when used in a Storyboard). Adapt and use a temporary window.
                isUIKitFlatMode = [[UIWindow new] respondsToSelector:@selector(tintColor)];
            }
        }
    });
    return isUIKitFlatMode;
}

- (id)init
{
    self = [super init];
    if (self) {
        //_imageAlignment = CalendarMenuImageAlignmentRight;
        _closeOnSelection = YES;   //选择之后关闭下拉菜单
        _waitUntilAnimationIsComplete = YES;
        
        _itemHeight = 35.0;
        _itemWidth = 100.0;  //下拉菜单的大小设置
        
        _separatorHeight = 1.0;  //分割线高度
        _separatorOffset = CGSizeMake(0, 0);
        
        _textOffset = CGSizeMake(15, 0);
        _font = [UIFont boldSystemFontOfSize:18.0];
        
        _backgroundAlpha = 1.0;
        _backgroundColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1.0];
        _separatorColor=[UIColor lightGrayColor];
//        _separatorColor = [UIColor colorWithPatternImage:self.separatorImage];
        _textColor = [UIColor colorWithRed:128/255.0 green:126/255.0 blue:124/255.0 alpha:1.0];
        _textShadowColor = [UIColor blackColor];
        _textShadowOffset = CGSizeMake(0, -1.0);
        _textAlignment = NSTextAlignmentLeft;  //item 字 左对齐
        
        
        _borderWidth = 1.0;  //边界线宽度
        _borderColor =  [UIColor colorWithRed:27/255.0 green:28/255.0 blue:27/255.0 alpha:1.0];
        _animationDuration = 0.3;
        _closeAnimationDuration = 0.2;
        _bounce = NO;  //菜单弹跳 no
        _bounceAnimationDuration = 0.2;
        
        
        _appearsBehindNavigationBar = CalendarUIKitIsFlatMode() ? YES : NO;
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [self init];
    if (self) {
        _items = items;
    }
    return self;
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view  //
{
    if (self.isAnimating) {
        return;
    }
    
    self.isOpen = YES;
    self.isAnimating = YES;
    
    // Create views
    //
    self.containerView = ({
        CalendarMenuContainerView *view = [[CalendarMenuContainerView alloc] init];
        view.clipsToBounds = YES;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;  //自适应调整宽度

        if (self.backgroundView) {
            self.backgroundView.alpha = 0;
            [view addSubview:self.backgroundView];
        }
        view;
    });
    
    self.menuView = ({  // menu视图
        UIView *view = [[UIView alloc] init];
        if (!self.liveBlur || !CalendarUIKitIsFlatMode()) {
//            view.backgroundColor = self.backgroundColor;
            view.backgroundColor=[UIColor whiteColor];
        }
        view.layer.cornerRadius = self.cornerRadius;
        view.layer.borderColor = self.borderColor.CGColor;
        view.layer.borderWidth = self.borderWidth;
        view.layer.masksToBounds = YES;
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = [UIScreen mainScreen].scale;  //像素设置
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        view;
    });
    
    if (CalendarUIKitIsFlatMode()) {
        self.toolbar = ({
            UIToolbar *toolbar = [[UIToolbar alloc] init];
            toolbar.barStyle = (UIBarStyle)self.liveBlurBackgroundStyle;
            if ([toolbar respondsToSelector:@selector(setBarTintColor:)])
                [toolbar performSelector:@selector(setBarTintColor:) withObject:self.liveBlurTintColor];
            toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            toolbar.layer.cornerRadius = self.cornerRadius;
            toolbar.layer.borderColor = self.borderColor.CGColor;
            toolbar.layer.borderWidth = self.borderWidth;
            toolbar.layer.masksToBounds = YES;
            toolbar;
        });
    }
    
    self.menuWrapperView = ({
        UIView *view = [[UIView alloc] init];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (!self.liveBlur || !CalendarUIKitIsFlatMode()) {
            view.layer.shadowColor = self.shadowColor.CGColor;
            view.layer.shadowOffset = self.shadowOffset;
            view.layer.shadowOpacity = self.shadowOpacity;
            view.layer.shadowRadius = self.shadowRadius;
            view.layer.shouldRasterize = YES;
            view.layer.rasterizationScale = [UIScreen mainScreen].scale;
        }
        view;
    });
    
    self.backgroundButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        button.accessibilityLabel = NSLocalizedString(@"Menu background", @"Menu background");
        button.accessibilityHint = NSLocalizedString(@"Double tap to close", @"Double tap to close");
        [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    CGFloat navigationBarOffset = self.appearsBehindNavigationBar && self.navigationBar ? 0: 0;  //menu item的位置offset 设置
    
    // Append new item views to CalendarMenuView
    //
    for (CalendarMenuItem *item in self.items) {
        NSInteger index = [self.items indexOfObject:item]; 
        
        CGFloat itemHeight = self.itemHeight;
        //CGFloat itemWidth = self.itemWidth;
        if (index == self.items.count -1)
            itemHeight += self.cornerRadius;
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(self.separatorOffset.width,
                                                                        index * self.itemHeight + index * self.separatorHeight + 40.0+navigationBarOffset + self.separatorOffset.height,
                                                                         self.itemWidth - self.separatorOffset.width * 2.0,
                                                                         self.separatorHeight)];
        separatorView.backgroundColor = self.separatorColor;
        //separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.menuView addSubview:separatorView];
        
        CalendarMenuItemView *itemView = [[CalendarMenuItemView alloc] initWithFrame:CGRectMake(0,
                                                                            index * self.itemHeight + (index + 1.0) * self.separatorHeight + 40.0 + navigationBarOffset,
                                                                                    self.itemWidth,
                                                                                    self.itemHeight)  //menu 起始位置和方块大小
                                                                    menu:self item:item];
        itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        item.itemView = itemView;
        itemView.separatorView = separatorView;
        itemView.autoresizesSubviews = YES;  // 子视图会根据autoresizingMask属性的值自动进行尺寸调整
        
        if (item.customView) {
            item.customView.frame = itemView.bounds;
            [itemView addSubview:item.customView];
        }
        [self.menuView addSubview:itemView];
    }
    
    // Set up frames
    //  menu 封装 frame, 关乎于 菜单下拉时的动画效果
    self.menuWrapperView.frame = CGRectMake(0, -self.combinedHeight - navigationBarOffset, _itemWidth, self.combinedHeight + navigationBarOffset);
    self.menuView.frame = self.menuWrapperView.bounds;
    if (CalendarUIKitIsFlatMode() && self.liveBlur) {
        self.toolbar.frame = self.menuWrapperView.bounds;
    }
    
    // container frame 位置和大小, 决定了下拉菜单的位置和大小, rect表示 屏幕rectangle
    self.containerView.frame = CGRectMake(rect.size.width - _itemWidth, rect.origin.y, _itemWidth, rect.size.height);
    self.backgroundButton.frame = self.containerView.bounds;
    
    // Add subviews
    //
    if (CalendarUIKitIsFlatMode() && self.liveBlur) {
        [self.menuWrapperView addSubview:self.toolbar];
    }
    [self.menuWrapperView addSubview:self.menuView];
    [self.containerView addSubview:self.backgroundButton];
    [self.containerView addSubview:self.menuWrapperView];
    [view addSubview:self.containerView];
    
    if ([self.delegate respondsToSelector:@selector(willOpenMenu:)]) {
        [self.delegate willOpenMenu:self];
    }
    
    // Animate appearance 动画效果
    //
    if (self.bounce) {
        self.isAnimating = YES;
        if ([UIView respondsToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)]) {
            [UIView animateWithDuration:self.animationDuration+self.bounceAnimationDuration
                                  delay:0.0
                 usingSpringWithDamping:0.6
                  initialSpringVelocity:4.0
                                options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.backgroundView.alpha = self.backgroundAlpha;
                                 CGRect frame = self.menuView.frame;
                                 frame.origin.y = -40.0 - self.separatorHeight;
                                 self.menuWrapperView.frame = frame;
                             } completion:^(BOOL finished) {
                                 self.isAnimating = NO;
                                 if ([self.delegate respondsToSelector:@selector(didOpenMenu:)]) {
                                     [self.delegate didOpenMenu:self];
                                 }
                             }];
        } else {
            [UIView animateWithDuration:self.animationDuration
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.backgroundView.alpha = self.backgroundAlpha;
                                 CGRect frame = self.menuView.frame;
                                 frame.origin.y = -40.0 - self.separatorHeight;
                                 self.menuWrapperView.frame = frame;
                             } completion:^(BOOL finished) {
                                 self.isAnimating = NO;
                                 if ([self.delegate respondsToSelector:@selector(didOpenMenu:)]) {
                                     [self.delegate didOpenMenu:self];
                                 }
                             }];
            
        }
    } else {  // 不弹跳
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backgroundView.alpha = self.backgroundAlpha;
                             CGRect frame = self.menuView.frame;
                             frame.origin.y = -40.0 - self.separatorHeight;
                            self.menuWrapperView.frame = frame;
                         } completion:^(BOOL finished) {
                             self.isAnimating = NO;
                             if ([self.delegate respondsToSelector:@selector(didOpenMenu:)]) {
                                 [self.delegate didOpenMenu:self];
                             }
                         }];
    }
}

- (void)showInView:(UIView *)view
{
    [self showFromRect:view.bounds inView:view];
}

- (void)showFromNavigationController:(UINavigationController *)navigationController
{
    if (self.isAnimating) {
        return;
    }
    self.navigationBar = navigationController.navigationBar;
    [self showFromRect:CGRectMake(0, 0, navigationController.navigationBar.frame.size.width, navigationController.view.frame.size.height) inView:navigationController.view];
    self.containerView.appearsBehindNavigationBar = self.appearsBehindNavigationBar;
    self.containerView.navigationBar = navigationController.navigationBar;
    if (self.appearsBehindNavigationBar) {
        [navigationController.view bringSubviewToFront:navigationController.navigationBar];
    }
}
// 关闭下拉菜单 事件
- (void)closeWithCompletion:(void (^)(void))completion
{
    if (self.isAnimating) return;
    
    self.isAnimating = YES;
    
    CGFloat navigationBarOffset = self.appearsBehindNavigationBar && self.navigationBar ? 64 : 0;
    
    void (^closeMenu)(void) = ^{
        [UIView animateWithDuration:self.closeAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             CGRect frame = self.menuView.frame;
                             frame.origin.y = - self.combinedHeight - navigationBarOffset;
                             self.menuWrapperView.frame = frame;
                             self.backgroundView.alpha = 0;
                         } completion:^(BOOL finished) {
                             self.isOpen = NO;
                             self.isAnimating = NO;
                             
                             [self.menuView removeFromSuperview];
                             [self.menuWrapperView removeFromSuperview];
                             [self.backgroundButton removeFromSuperview];
                             [self.backgroundView removeFromSuperview];
                             [self.containerView removeFromSuperview];
                             
                             if (completion) {
                                 completion();
                             }
                             
                             if (self.closeCompletionHandler) {
                                 self.closeCompletionHandler();
                             }
                             if ([self.delegate respondsToSelector:@selector(didCloseMenu:)]) {
                                 [self.delegate didCloseMenu:self];
                             }
                         }];
        
    };
    
    if (self.closePreparationBlock) {
        self.closePreparationBlock();
    }
    if ([self.delegate respondsToSelector:@selector(willCloseMenu:)]) {
        [self.delegate willCloseMenu:self];
    }
    
    if (self.bounce) {
        [UIView animateWithDuration:self.bounceAnimationDuration animations:^{
            CGRect frame = self.menuView.frame;
            frame.origin.y = -20.0;
            self.menuWrapperView.frame = frame;
        } completion:^(BOOL finished) {
            closeMenu();
        }];
    } else {
        closeMenu();
    }
}

- (void)close
{
    [self closeWithCompletion:nil];
}

- (CGFloat)combinedHeight  //菜单高度和计算
{
    return self.items.count * self.itemHeight + self.items.count * self.separatorHeight + 40.0 + self.cornerRadius;
}

- (void)setNeedsLayout
{
    [UIView animateWithDuration:0.35 animations:^{
        [self.containerView layoutSubviews];
    }];
}

#pragma mark -
#pragma mark Setting style
// 分割线 图片格式
- (UIImage *)separatorImage
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 4.0));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1.0, 2.0));
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:79/255.0 green:79/255.0 blue:77/255.0 alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, 3.0, 1.0, 2.0));
    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:outputImage.CGImage scale:2.0 orientation:UIImageOrientationUp];
}


@end
