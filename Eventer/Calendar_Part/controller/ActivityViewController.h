//
//  ActivityViewController.h
//  Calendar
//
//  Created by emma on 15/4/23.
//  Copyright (c) 2015年 Emma. All rights reserved.
//


//#import "ScrollingNavbarViewController.h"
#import "MenuRootViewController.h"
#import "LeftSwipeDeleteTableView.h"
#import "ActivitySegmentViewController.h"

//typedef void(^BackBlock)(void);

@interface ActivityViewController : MenuRootViewController


@property (nonatomic, retain) ActivitySegmentViewController *segmentView;
@property (nonatomic, retain) NSMutableArray   *activitiesArray;
//用来保存segmentcontrol点击的数字，从而对添加事件作出判断，添加的事件到底是要做的还是收藏的
@property (nonatomic, retain) NSString *segmentIndex;


@end
