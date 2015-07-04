//
//  CourseEditVC.m
//  Eventer
//
//  Created by admin on 15/6/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "CourseEditVC.h"
#import "labelEditCell.h"
@interface CourseEditVC ()

@end

@implementation CourseEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"编辑课程";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(editActionComplete)];
    self.tableView.scrollEnabled=NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)editActionComplete{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (section==0) {
        return 3;
    }else if (section==1){
        return 2;
    }else{
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"editCell";
    labelEditCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[labelEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.section==0)
    {


        switch (indexPath.row) {
            case 0:
                cell.cellTitle=@"名称";
                cell.cellContant=self.course.CourseName;
                break;
            case 1:
                cell.cellTitle=@"老师";
                cell.cellContant=self.course.Teacher;
                break;
            case 2:
                cell.cellTitle=@"教室";
                cell.cellContant=self.course.Place;
                break;
            default:
                break;
        }
        return cell;
    
    }else{
        
        switch (indexPath.row) {
            case 0:
                cell.cellTitle=@"节数";
                cell.cellContant=[NSString stringWithFormat:@"%@-%d",self.course.lesson,[self.course.lessonNum intValue]+[self.course.lesson intValue]];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.cellTitle=@"周数";
                cell.cellContant=[NSString stringWithFormat:@"%@-%@",self.course.StartWeek,self.course.EndWeek];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 300;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    labelEditCell* cell = (labelEditCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

//不显示没有的格子
- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

@end
