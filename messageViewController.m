//
//  messageViewController.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "messageViewController.h"
#import "boardCell.h"
#import "MyChatRoom.h"
#import "contactViewController.h"
#import "ViewController.h"
#import "databaseService.h"
#import "chatRecord.h"
#import "chatRecordCell.h"
#import "WXViewController.h"
#import "contactListViewController.h"




@interface messageViewController ()
{
    NSMutableArray *_chatItems;
    NSMutableArray *_chatItemCells;
    NSArray *titlelists;
}

@end

@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"发起消息" style:UIBarButtonItemStylePlain target:self action:@selector(enterContactList)];
    UIBarButtonItem *backbutton= self.navigationItem.backBarButtonItem;
    backbutton.title=@"返回";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addChat:) name:@"addChatRecordNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateChat:) name:@"updateChatRecordNotification" object:nil];
//    self.refreshControl = [[UIRefreshControl alloc]init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
//    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self loadData];
//    NSTimeInterval timeInterval =15 ;
//    NSTimer * reloaddata=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(reloadRecord:) userInfo:nil repeats:YES];
}
-(void)addChat:(NSNotification*)notification{
    NSLog(@"addchatrecord");
    chatRecord*chat=[[chatRecord alloc]initWithDictionary:notification.object];
    [_chatItems addObject:chat];
    chatRecordCell*chatCell=[[chatRecordCell alloc]init];
    [_chatItemCells addObject:chatCell];
    [self.tableView reloadData];
}

-(void)updateChat:(NSNotification*)notification{
    NSLog(@"updatechatrecord");
//    [self.tableView reloadRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>];
}


-(void)reloadRecord:(NSTimer*)timer
{
    [self loadData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)enterContactList
{
    contactListViewController *contactviewcontroller=[[contactListViewController alloc]init];
    [self.navigationController pushViewController:contactviewcontroller animated:YES];
}
-(void)loadData
{
    //    NSDictionary*order=[NSDictionary dictionaryWithObject:@"DESC" forKey:@"time"];
    //    NSDictionary*results=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbMessage" WithCondition:nil orderby:order];
    
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    NSDictionary*results=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"chatRecord" WithCondition:nil];
    _chatItems = [NSMutableArray array];
    _chatItemCells = [NSMutableArray array];
    if (results) {
        NSArray*array=[results allValues];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_chatItems addObject:[chatRecord chatRecordWithDic:obj]];
            chatRecordCell * cell = [[chatRecordCell alloc]init];
            [_chatItemCells addObject:cell];
        }];
    }
    
    titlelists=@[@"我的讨论室",@"活动分享板"];
    [self.tableView reloadData];
    
}


#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _chatItems.count+2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=indexPath.row;
    
    if (row<=1)
    {
        static NSString * identifier = @"Cell";
        boardCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[boardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.name=titlelists[indexPath.row];
        return cell;
    }else
    {
        static NSString * identifier = @"cell00";
        chatRecordCell*cell2;
        cell2=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell2) {
            cell2 = [[chatRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        chatRecord * chat = _chatItems[row-2];
        cell2.chatRecord = chat;
        return cell2;
    }
}



#pragma mark - 代理方法
#pragma mark 重新设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    if (row<=1) {
        
        return 44;
    }else{
        chatRecordCell * cell = _chatItemCells[row-2];
        cell.chatRecord = _chatItems[row-2];
        return cell.height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row=indexPath.row;
    if (row==0) {
        MyChatRoom *rooms=[[MyChatRoom alloc]init];
        [self.navigationController pushViewController:rooms animated:YES];}
    else if(row==1){WXViewController *share=[[WXViewController alloc]init];
        [self.navigationController pushViewController:share animated:YES];}
    else
    {
        ViewController *detail=[[ViewController alloc]init];
        chatRecord * chat = _chatItems[row-2];
        detail.name=chat.name;
        detail.avatar=chat.avatar;
        detail.participantId=chat.participantId;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}




@end
