//
//  sectionViewController.h
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sectionViewController : UITableViewController<UISearchDisplayDelegate>
@property(nonatomic,strong)NSArray* datatoload;
-(void)reload;

@end
