//
//  CalendarMenuContainerView.h
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarMenuContainerView : UIView

@property (strong, readwrite, nonatomic) UINavigationBar *navigationBar; //导航条
@property (assign, readwrite, nonatomic) BOOL appearsBehindNavigationBar;

@end
