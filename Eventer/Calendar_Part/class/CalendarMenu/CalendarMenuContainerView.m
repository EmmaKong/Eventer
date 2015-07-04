//
//  CalendarMenuContainerView.m
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CalendarMenuContainerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CalendarMenuContainerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 不设置 横屏
    // UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // iphone style or ipad
    //CGFloat landscapeOffset = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 32.0 : 44.0;
    
    if (self.navigationBar && !self.appearsBehindNavigationBar) {
        CGRect frame = self.frame;
        frame.origin.y = self.navigationBar.frame.origin.y + 44.0;
    
        self.frame = frame;
    }
    
    if (self.appearsBehindNavigationBar) {  //frame 纵坐标 起始位置设置
        CGRect frame = self.frame;
        frame.origin.y = 64;
        self.frame = frame;
    }
}

@end
