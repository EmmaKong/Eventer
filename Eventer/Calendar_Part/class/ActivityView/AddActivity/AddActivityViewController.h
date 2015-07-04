//
//  AddActivityViewController.h
//  Calendar
//
//  Created by emma on 15/6/3.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailTableViewController.h"
#import "Activity.h"
#import "ActivityTimePickerView.h"

@interface AddActivityViewController : UIViewController< UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIScrollView *editscroll;
    UIView* editcurrentView;
    UITextField *titlefield;
    UITextField *datefield;
    UITextField *addressfield;
    UITextField *sponsorfield;
    UITextView *detailfield;
}

@property (nonatomic,retain) Activity *activity;
//viewindex为0则表示添加到要完成事件清单，为1则添加到收藏事件清单
@property (nonatomic,retain) NSString *viewIndex;
@property (nonatomic,retain) UILabel *timeLabel;



@end
