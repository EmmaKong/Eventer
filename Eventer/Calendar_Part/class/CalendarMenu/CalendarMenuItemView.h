//
//  CalendarMenuItemView.h
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

//#import <UIKit/ UIKit.h>
#import "CalendarMenuItem.h"
#import "CalendarMenu.h"

@class CalendarMenu;
@class CalendarMenuItem;

@interface CalendarMenuItemView : UIView


@property (weak, readwrite, nonatomic) CalendarMenu *menu;
@property (weak, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CalendarMenuItem *item;

- (id)initWithFrame:(CGRect)frame menu:(CalendarMenu *)menu item:(CalendarMenuItem*) item ;


@end
