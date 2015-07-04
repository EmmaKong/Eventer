//
//  ActivityItemCell.h
//  Calendar
//
//  Created by emma on 15/6/11.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityItemCellDelegate <NSObject>


@end

@interface ActivityItemCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;


@property (assign, nonatomic) id<ActivityItemCellDelegate> delegate;
@end
