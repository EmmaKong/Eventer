//
//  AllMemberViewController.m
//  BRSliderController
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "AllMemberViewController.h"
#import "member.h"
#import "MemberCell.h"
#import "MemberGroup.h"
#import "databaseService.h"

#define kSearchbarHeight 44

@interface AllMemberViewController (){
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    NSMutableArray *_members;//联系人模型
    NSMutableArray *_searchContacts;//符合条件的搜索联系人
    BOOL _isSearching;
}

@end

@implementation AllMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}

-(void)initData{
//    NSDictionary*managerCondition=[NSDictionary dictionaryWithObject:<#(id)#> forKey:@"type"];
    NSArray*participants=[[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbUser" WithCondition:nil]allValues];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type== contains [cd] %@||self[1] contains [cd] %@",用户输入的string,用户输入string];
    
//    filterData = [[NSArray alloc] initWithArray:[contacts filteredArrayUsingPredicate:predicate]];
    _members=[NSMutableArray arrayWithArray:participants];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isSearching) {
        return 1;
    }
    return _members.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearching) {
        return _searchContacts.count;
    }
    MemberGroup *group1=_members[section];
    return group1.members.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    member *contact=nil;
    
    if (_isSearching) {
        contact=_searchContacts[indexPath.row];
    }else{
        MemberGroup *group=_members[indexPath.section];
        contact=group.members[indexPath.row];
    }
    
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    
    //首先根据标示去缓存池取
    MemberCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //如果缓存池没有取到则重新创建并放到缓存池中
    if(!cell){
        cell=[[MemberCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.member=contact;
    
    return cell;
}

#pragma mark - 代理方法
#pragma mark 设置分组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    MemberGroup *group=_members[section];
    return group.name;
}


#pragma mark - 搜索框代理
#pragma mark  取消搜索
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _isSearching=NO;
    _searchBar.text=@"";
    [_tableView reloadData];
}

#pragma mark 输入搜索关键字
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([_searchBar.text isEqual:@""]){
        _isSearching=NO;
        [_tableView reloadData];
        return;
    }
    [self searchDataWithKeyWord:_searchBar.text];
}

#pragma mark 点击虚拟键盘上的搜索时
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self searchDataWithKeyWord:_searchBar.text];
    
    [_searchBar resignFirstResponder];//放弃第一响应者对象，关闭虚拟键盘
}




#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 搜索形成新数据
//注意这里只搜索firstName
-(void)searchDataWithKeyWord:(NSString *)keyWord{
    _isSearching=YES;
    _searchContacts=[NSMutableArray array];
    [_members enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MemberGroup *group=obj;
        [group.members enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            member *contact=obj;
            if ([contact.ScreenName.uppercaseString containsString:keyWord.uppercaseString]) {
                [_searchContacts addObject:contact];
            }
        }];
    }];
    
    //刷新表格
    [_tableView reloadData];
}

#pragma mark 添加搜索栏
-(void)addSearchBar{
    CGRect searchBarRect=CGRectMake(0, 0, self.view.frame.size.width, kSearchbarHeight);
    _searchBar=[[UISearchBar alloc]initWithFrame:searchBarRect];
    _searchBar.placeholder=@"Please input key word...";
    //_searchBar.keyboardType=UIKeyboardTypeAlphabet;//键盘类型
    //_searchBar.autocorrectionType=UITextAutocorrectionTypeNo;//自动纠错类型
    //_searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;//哪一次shitf被自动按下
    _searchBar.showsCancelButton=YES;//显示取消按钮
    //添加搜索框到页眉位置
    _searchBar.delegate=self;
    _tableView.tableHeaderView=_searchBar;
        _searchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
        _searchDisplayController.searchResultsDataSource=self;
        _searchDisplayController.searchResultsDelegate=self;
        [_searchDisplayController setActive:NO];
}


@end
