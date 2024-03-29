//
//  AddedCourseDetailVC.m
//  Calendar
//
//  Created by emma on 15/6/3.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "AddedCourseDetailVC.h"
#import "CourseInfoCell.h"
#import "CoursePeerCell.h"
#import "ClassPeerViewController.h"
#import "databaseService.h"
#import "CourseEditVC.h"

@interface AddedCourseDetailVC ()

@end

@implementation AddedCourseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程详情";
}
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];  // grouped tableview
    if(!self){
        return nil;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGFloat padding = 20;
    
    NSLog(@"%@",self.weekcourse.CourseID);
    CourseInfoCell *infoCell = [[CourseInfoCell alloc] init: self.weekcourse];
    CourseDetailSection *detailSection = [CourseDetailSection sectionWithHeaderTitle:nil cells:@[infoCell]];
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editBtn.frame = CGRectMake(infoCell.frame.size.width - padding - 50, (infoCell.frame.size.height - 20)/2, 50 , 20);
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    editBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickeditBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [infoCell.contentView addSubview:editBtn];

    CoursePeerCell *peerCell = [[CoursePeerCell alloc] init];
    //同伴查看按钮
    UIButton *peerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    peerBtn.frame = CGRectMake(peerCell.frame.size.width - padding - 50, padding, 50 , 20);
    
    peerBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    peerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [peerBtn setTitle:@"查看" forState:UIControlStateNormal];
    [peerBtn addTarget:self action:@selector(clickPeerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [peerCell.contentView addSubview:peerBtn];
    
    CourseDetailSection *peerSection = [CourseDetailSection sectionWithHeaderTitle:nil cells:@[peerCell]];
    
    
    CourseDetailCell *deleteCell = [CourseDetailCell cellWithStyle:UITableViewCellStyleDefault height:44 actionBlock:^{
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该课程吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil] show];
    }];
    
    deleteCell.textLabel.text = @"删除本节课";
    deleteCell.textLabel.textColor = [UIColor redColor];
    deleteCell.textLabel.textAlignment = NSTextAlignmentCenter;
    CourseDetailSection  *deleteSection = [CourseDetailSection  sectionWithHeaderTitle:nil cells:@[deleteCell]];
    
    self.sections = @[detailSection, peerSection, deleteSection];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 取消， 删除的索引buttonindex分别是0，1
    
    if (buttonIndex == 0) {
        //点击取消
    }else { //  确定删除该课程
        //第一步注册 删除课程 通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deletecourseNotification" object:self.weekcourse];

        //删除当周的该项课程，而不是删除所有的，所以仅需要更新表的noclassweek字段
//        NSDictionary*noClassWeekchange=[]
//        [databaseService shareddatabaseService]updateTable:<#(NSString *)#> WithChanges:<#(NSDictionary *)#> AndConditions:<#(NSDictionary *)#>
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
}

-(void)clickeditBtn:(id)sender{
    CourseEditVC*editvc=[[CourseEditVC alloc]init];
    editvc.course=self.weekcourse;

    [self.navigationController pushViewController:editvc animated:YES];
    
}


-(void)clickPeerBtn:(id)sender{
    
    ClassPeerViewController* classpeerVC = [[ClassPeerViewController alloc]init];
    [self.navigationController pushViewController:classpeerVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
