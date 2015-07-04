//
//  sectionViewController.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "sectionViewController.h"
#import "event.h"
#import "eventCell.h"
#import "databaseService.h"

@interface sectionViewController ()
{
    NSMutableArray * _activity;
    NSMutableArray *_activityCells;//存储cell，用于计算高度
}
@end

@implementation sectionViewController
{
    NSMutableArray*filterdEvents;
    UISearchDisplayController* searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark 加载数据
- (void)initData{
    databaseService* sqlmanager=[[databaseService alloc]init];
    [sqlmanager useDatabaseWithName:@"eventer.db"];
    
    
    
    NSDictionary*condition=[NSDictionary dictionaryWithObject:@"0" forKey:@"ztype"];
    NSDictionary*order=[NSDictionary dictionaryWithObjectsAndKeys:@"DESC",@"zpubtime",@"ASC",@"zsource", nil];
    NSDictionary*result=[sqlmanager get:@"ALL" FromTable:@"dbEvent" WithCondition:condition orderby:order];
    _activity = [NSMutableArray array];
    _activityCells = [NSMutableArray array];
    NSArray*array=[NSArray arrayWithArray:[result allValues]];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_activity addObject:[event eventWithDictionary:obj]];
        eventCell * cell = [[eventCell alloc]init];
        [_activityCells addObject:cell];
    }];
    
}
-(void)reload{
    databaseService* sqlmanager=[[databaseService alloc]init];
    [sqlmanager useDatabaseWithName:@"eventer.db"];
    _activity = [NSMutableArray array];
    _activityCells = [NSMutableArray array];
    NSArray*array=[NSArray arrayWithArray:self.datatoload];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_activity addObject:[event eventWithDictionary:obj]];
        eventCell * cell = [[eventCell alloc]init];
        [_activityCells addObject:cell];
    }];
    [self.tableView reloadData];
    
}

#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _activity.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"Cell";
    eventCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[eventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    event *event = _activity[indexPath.row];
    cell.event = event;
    return cell;
}

#pragma mark - 代理方法
#pragma mark 重新设置行高
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"click %ld",(long)indexPath.row);
    UITableViewController*detail=[[UITableViewController alloc]init];
    detail.title=@"detail";
    [self presentViewController:detail animated:NO completion:nil];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    eventCell * cell = _activityCells[indexPath.row];
    cell.event = _activity[indexPath.row];
    return cell.height;
}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
