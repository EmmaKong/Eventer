//
//  eventCell.h
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class event;
@interface eventCell : UITableViewCell


@property (nonatomic ,strong) event * event;

#pragma mark 单元格高度
@property (nonatomic ,assign) CGFloat height;
@end
