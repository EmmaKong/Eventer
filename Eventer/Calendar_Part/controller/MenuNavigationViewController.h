//
//  MenuNavigationViewController.h
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarMenu.h"

@interface MenuNavigationViewController : UINavigationController

@property (strong, readonly, nonatomic) CalendarMenu *menu;

- (void)toggleMenu;


@end
