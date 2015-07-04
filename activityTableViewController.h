//
//  activityTableViewController.h
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imagedisplayCell.h"

@interface activityTableViewController : UITableViewController<UIScrollViewDelegate,UISearchDisplayDelegate,UISearchControllerDelegate,showImgDetailDelagate>
@property(copy,nonatomic)NSDictionary*events;

@end
