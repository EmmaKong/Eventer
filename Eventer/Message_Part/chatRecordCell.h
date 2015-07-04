//
//  chatRecordCell.h
//  BRSliderController
//
//  Created by admin on 15/5/27.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class chatRecord;
@interface chatRecordCell : UITableViewCell
@property (nonatomic,strong) chatRecord *chatRecord;
@property (nonatomic ,assign) CGFloat height;
@end
