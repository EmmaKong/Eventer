//
//  AllMemberViewController.h
//  BRSliderController
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllMemberViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,copy)NSString* roomId;
@end
