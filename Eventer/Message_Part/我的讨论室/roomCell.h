//
//  roomCell.h
//  BRSliderController
//
//  Created by admin on 15/4/29.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class roomData;
@interface roomCell : UITableViewCell
@property (nonatomic ,strong) roomData * roomdata;

#pragma mark 单元格高度
@property (nonatomic ,assign) CGFloat height;
@end
