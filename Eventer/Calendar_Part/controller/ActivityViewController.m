//
//  ActivityViewController.m
//  Calendar
//
//  Created by emma on 15/4/23.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ActivityViewController.h"

#import "ActivityDetailViewController.h"
#import "AddActivityViewController.h"



@interface ActivityViewController ()

@end

@implementation ActivityViewController

-(instancetype)init{
    self=[super init];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tabBarController.tabBar.translucent=NO;
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(segmentControlChangeState:) name:@"segmentControlChangeState" object:nil];

    self.title = @"事项列表";
    self.view.backgroundColor = [UIColor clearColor];
    
    _segmentView = [[ActivitySegmentViewController alloc] init];

    // 将 segmentviewcontroller 添加至activityviewcontroller
    [self addChildViewController:_segmentView];
    [self.view addSubview:_segmentView.view];
 
    
    //左侧 添加事项按钮
    UIButton *addactivityButton = [UIButton  buttonWithType:UIButtonTypeContactAdd];
    addactivityButton.frame = CGRectMake(0, 0, 30, 30);
    [addactivityButton addTarget:self action:@selector(addActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addactivityItem = [[UIBarButtonItem alloc] initWithCustomView:addactivityButton];
    self.navigationItem.leftBarButtonItem = addactivityItem;
    
    
}


// 添加事项 action
- (void)addActivityAction:(id)sender{
//    overLayView.hidden = NO;
//    activityView.hidden = NO;
//    
//    //动画
//    activityView.transform = CGAffineTransformMakeScale(1.3, 1.3);
//    activityView.alpha = 0;
//    [UIView animateWithDuration:.35 animations:^{
//        activityView.alpha = 1;
//        activityView.transform = CGAffineTransformMakeScale(1, 1);
//    }];
//    
    
    AddActivityViewController *addViewController = [[AddActivityViewController alloc] init];
    NSLog(@"向add传递标签%@",self.segmentIndex);
    addViewController.viewIndex=self.segmentIndex;
    [self.navigationController pushViewController:addViewController animated:YES];
    
}

-(void)segmentControlChangeState:(NSNotification *)notification{
    NSString*obj=[notification object];
    self.segmentIndex=obj;
}



@end
