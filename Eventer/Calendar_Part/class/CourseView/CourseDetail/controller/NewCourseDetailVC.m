//
//  CourseDetailViewController.m
//  CourseDetail
//
//  Created by emma on 15/5/22.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "NewCourseDetailVC.h"
#import "CourseInfoEditCell.h"
#import "CoursePeerCell.h"
#import "ClassPeerViewController.h"
#import "databaseService.h"

@interface NewCourseDetailVC ()

@end

@implementation NewCourseDetailVC

-(void)viewDidLoad{
    [super viewDidLoad];
self.title = @"添加课程详情";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(addCourse)];
}

-(void)addCourse{
    WeekCourse*newcourse=[[WeekCourse alloc]init];
    newcourse=self.weekcourse;
    NSDictionary*courseDic=[NSDictionary dictionaryWithObjectsAndKeys:newcourse.CourseID,@"CourseID",newcourse.CourseName,@"CourseName",newcourse.Place,@"Place",newcourse.lesson,@"lesson",newcourse.lessonNum,@"lessonNum",newcourse.Teacher,@"Teacher",newcourse.Companion,@"Companion",newcourse.Status,@"Status",newcourse.StartWeek,@"StartWeek",newcourse.EndWeek,@"EndWeek",newcourse.NoClassWeek,@"NoClassWeek",newcourse.TeacherEmail,@"TeacherEmail",newcourse.TeacherTel,@"TeacherTel",newcourse.color,@"color",newcourse.weekDay,@"weekDay",nil];
    [[databaseService shareddatabaseService]insert:courseDic toTable:@"dbCourse"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addcourseNotification" object:self.weekcourse];

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
    NSLog(@"%@",self.weekcourse.CourseID);
    
    
    CourseInfoEditCell *infoCell = [[CourseInfoEditCell alloc] init: self.weekcourse];
    CourseDetailSection *detailSection = [CourseDetailSection sectionWithHeaderTitle:nil cells:@[infoCell]];


    CoursePeerCell *peerCell = [[CoursePeerCell alloc] init];
    CourseDetailSection *peerSection = [CourseDetailSection sectionWithHeaderTitle:nil cells:@[peerCell]];
    
    
    self.sections = @[detailSection, peerSection];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
