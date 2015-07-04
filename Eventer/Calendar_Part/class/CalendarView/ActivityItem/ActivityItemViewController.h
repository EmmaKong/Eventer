//
//  ActivityItemViewController.h
//  Calendar
//
//  Created by emma on 15/6/11.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekCourse.h"
#import "Activity.h"
#import "ActivityItemCell.h"
#import "Item.h"

@interface ActivityItemViewController : UIViewController<ActivityItemCellDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *itemtableView;

}

@property (nonatomic, retain) NSMutableArray   *todoactivityArray;
@property (nonatomic, retain) NSMutableArray   *todocourseArray;
@property (nonatomic, retain) NSMutableArray   *todoArray;

@end
