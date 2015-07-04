//
//  activityTableViewController.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "activityTableViewController.h"
#import "SliderViewController.h"
#import "databaseService.h"
#import "eventCell.h"
#import "event.h"



//#import "ViewController.h"
@interface activityTableViewController ()
{
    NSMutableArray *_activity;
    NSMutableArray *_activitycell;
    databaseService*servicemanager;
    
}

@end

@implementation activityTableViewController
{
    NSMutableArray*filterdEvents;
    UISearchDisplayController* searchController;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"活动";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchevent)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(addmore)];
    UIBarButtonItem *backbutton= self.navigationItem.backBarButtonItem;
    backbutton.title=@"返回";
    
    
    [self initData];
    
    
    //    self.tableView=(id)[self.view viewWithTag:1];
    //    filterdEvents=[NSMutableArray array];
    
    //    searchController=[[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    //    searchController.delegate=self;
    //    searchController.searchResultsDataSource=self;
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        
        NSDate *now=[NSDate new];
        
        //notification.fireDate=[now addTimeInterval:period];
        NSTimeInterval period=10;
        notification.fireDate = [now dateByAddingTimeInterval:period];
        NSLog(@"%f",period);
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = @"ping.caf";
        //notification.alertBody=@"TIME！";

        notification.alertBody = [NSString stringWithFormat:@"时间到了!"];
        
        NSDictionary* info = [NSDictionary dictionaryWithObject:@"uniqueCodeStr" forKey:@"CODE"];
        notification.userInfo = info;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    }
    
    
}


#pragma UIsearchdisplaydelegate 委托方法
//-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
//{
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"filterdcell"];
//
//}
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [filterdEvents removeAllObjects];
//    if (searchString.length>0) {
////        NSPredicate*predicate=[NSPredicate predicateWithBlock:^BOOL(NSString*name,NSDictionary*b)
////        {
////            NSRange range=[name rangeOfString:searchString options:NSCaseInsensitiveSearch];
////            return range.location!=NSNotFound;
////        }];
//        NSPredicate*predicate=[NSPredicate predicateWithFormat:
//                               @"self contains [cd] %@",searchString];
//        NSArray*matches=[_activity filteredArrayUsingPredicate:predicate];
//        [filterdEvents addObjectsFromArray:matches];
//
//    }
//    return YES;
//}

-(void)addmore
{
    SliderViewController *test=[[SliderViewController alloc]init];
    [self.navigationController pushViewController:test animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    _activity = [NSMutableArray array];
    _activitycell = [NSMutableArray array];
 
//单例下的数据库操作
    

    NSDictionary*order=[NSDictionary dictionaryWithObject:@"DESC" forKey:@"zpubtime"];
    NSDictionary*result=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbEvent" WithCondition:nil orderby:order];
    NSArray*datashown=[result allValues];
    [datashown enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_activity addObject:[event eventWithDictionary:obj]];
        eventCell * cell = [[eventCell alloc]init];
        [_activitycell addObject:cell];
    }];
  
}


#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num=_activity.count+1;
    return num;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=indexPath.row;
    
    if (row==0)
    {
        static NSString * identifier = @"Cell";
        imagedisplayCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[imagedisplayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate=self;
        }
        
        return cell;
    }else
    {
        static NSString * identifier = @"cell2";
        eventCell *cell2;
        cell2=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell2) {
            cell2 = [[eventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        event * event = _activity[row-1];
        cell2.event = event;
        return cell2;
    }
}

#pragma mark - 代理方法
#pragma mark 重新设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    if (row==0) {
        
        return 220;
    }else{
        eventCell * cell = _activitycell[row-1];
        cell.event = _activity[row-1];
        return cell.height;}
}
-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=0) {
        return indexPath;
    }else
    {
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewController*detail=[[UITableViewController alloc]init];
    detail.title=@"detail";
    [self.navigationController pushViewController:detail animated:NO];
    
    
}



#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark showImgDetailDelagate
-(void)showDetail:(UITableViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
}



@end
