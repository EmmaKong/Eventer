//
//  MyChatRoom.m
//  BRSliderController
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "MyChatRoom.h"
#import "roomDetail.h"
#import "roomCell.h"
#import "databaseService.h"
#import "room.h"
#import "roomData.h"

@interface MyChatRoom ()

@end

@implementation MyChatRoom
{
    NSMutableArray*roomDataSource;
    NSMutableArray*_rooms;
    NSMutableArray*_roomcells;
}

-(MyChatRoom*)init{
    self=[super init];
    self.hidesBottomBarWhenPushed=YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [self configData];
    self.title=@"我的讨论室";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *backbutton= self.navigationItem.backBarButtonItem;
    backbutton.title=@"返回";
}

-(void)configData{
    roomDataSource=[[NSMutableArray alloc]init];
    _rooms=[NSMutableArray array];
    _roomcells=[NSMutableArray array];
    NSDictionary*order=[NSDictionary dictionaryWithObject:@"DESC" forKey:@"creatTime"];
    NSDictionary*roomResultDic=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbEventRoomList" WithCondition:nil orderby:order];
    NSInteger i;
    for (i=1; i<=[roomResultDic count]; i++) {
        NSDictionary*room=[roomResultDic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
        [roomDataSource addObject:room];
    }
    [roomDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        room*roomitem=[room roomWithDictionary:obj];
        [_rooms addObject:[roomData roomDataWithRoom:roomitem]];
        roomCell * cell = [[roomCell alloc]init];
        [_roomcells addObject:cell];
    }];
    NSLog(@"一共有%lu",(unsigned long)[_rooms count]);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_rooms count];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"cellForRoom";
    if ([_rooms count]>0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self setExtraCellLineHidden:tableView];
    }else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    roomCell*cell;
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[roomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];}
    cell.roomdata=_rooms[indexPath.row];
    return cell;

}



#pragma mark tableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    roomDetail*room=[[roomDetail alloc]init];
    room.roomIcon=[_rooms[indexPath.row]roomIcon];
    room.roomIntro=[_rooms[indexPath.row]roomIntro];
    room.roomName=[_rooms[indexPath.row]roomName];
    room.roomId=[_rooms[indexPath.row]roomId];
    [self.navigationController pushViewController:room animated:YES];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    roomCell * cell = _roomcells[row];
    cell.roomdata = _rooms[row];
    return cell.height;
}


//不显示没有的格子
- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}
//解决分割线左边缺失问题
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }  
}

@end
