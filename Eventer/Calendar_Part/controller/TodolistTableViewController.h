//
//  TodolistTableViewController.h
//  Calendar
//
//  Created by emma on 15/6/4.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVSegmentController.h"
#import "LeftSwipeDeleteTableView.h"
#import "ActivityCell.h"
#import "Activity.h"

//typedef void(^BackBlock)(void);


@interface TodolistTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AVSegmentControllerDelegate>

@property (nonatomic, retain) LeftSwipeDeleteTableView *tableView;


@property (nonatomic, retain) NSMutableArray   *activitiesArray;
@property (nonatomic, assign) NSInteger     clickIndex;

@end
