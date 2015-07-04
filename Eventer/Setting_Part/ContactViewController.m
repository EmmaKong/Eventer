//
//  ContactViewController.m
//  BRSliderController
//
//  Created by admin on 15/6/16.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "ContactViewController.h"
#import "MoreInfoMenu.h"
#import "ChineseString.h"
@interface ContactViewController ()<moreInfoViewDelegate,UISearchBarDelegate>
{

    BOOL isShown;
    
}
@property (strong, nonatomic) MoreInfoMenu *moreInfo;
@property (strong, nonatomic) NSArray *all_contact;//所有联系人
//@property (strong, nonatomic) NSMutableArray *contact_name;//联系人姓名数组
//@property (strong, nonatomic) NSArray *contact_pinyin;//联系人的拼音
//@property (strong, nonatomic) NSSet *firstLetter;
//@property (strong, nonatomic) NSSet *firstLetter;
//@property (strong, nonatomic) NSMutableArray*sectionTitles;
@property (strong, nonatomic) UISearchBar *searchBar;


@property(nonatomic,retain)NSMutableArray *LetterResultArr;
@property(nonatomic,retain)NSMutableArray *indexArray;
@end

@implementation ContactViewController{
    NSArray*contactNames;
}

- (void)viewDidLoad {
    isShown=NO;
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(ShowDropDownMenu)];
    self.searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 40)];
    [self.view addSubview:self.searchBar];
    self.tableView.tableHeaderView=self.searchBar;

    CFErrorRef error=NULL;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &error);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted,CFErrorRef error){
        if (granted) {
            [self filterContentForSearchText:@""];
        }
    });
    CFRelease(addressBook);
    contactNames=[NSArray array];
    contactNames=[self getContactInfo];
    self.indexArray = [ChineseString IndexArray:contactNames];
    self.LetterResultArr = [ChineseString LetterSortArray:contactNames];
}


//获取通讯录消息

-(void)filterContentForSearchText:(NSString*)searchText{
    if (ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized) {
        return;
    }
    CFErrorRef error=NULL;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &error);
    if ([searchText length]==0) {
        self.all_contact=CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    }else{
        CFStringRef cfSearchText=(CFStringRef)CFBridgingRetain(searchText);
        self.all_contact=CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
        CFRelease(cfSearchText);
    }
    [self.tableView reloadData];
    CFRelease(addressBook);
}

//获取联系人具体信息，如名字等

-(NSArray*)getContactInfo{
    NSMutableArray* contactNameArray=[NSMutableArray array];
    
    for (int i=0; i<[self.all_contact count]; i++) {
        ABRecordRef thisPerson = CFBridgingRetain(self.all_contact[i]);
        NSString* name = CFBridgingRelease(ABRecordCopyCompositeName(thisPerson));
        [contactNameArray addObject:name];
    }
    return contactNameArray;
}

//更多菜单

-(void)ShowDropDownMenu{
    isShown=!isShown;
    self.moreInfo=[[MoreInfoMenu alloc]init];
    self.moreInfo.tag=2015;
    [self.moreInfo setCellTitles:@[@"添加朋友",@"发起群聊"]];
     self.moreInfo.dataSource = self.moreInfo;
    self.moreInfo.delegate = self.moreInfo;
    [self.moreInfo reloadData];
    [self.moreInfo sizeToFit];
    self.moreInfo.frame=CGRectMake(2*self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 80);
    [self.view addSubview:self.moreInfo];
    self.moreInfo.backgroundColor=[UIColor blackColor];

    if (isShown==YES) {
        [self.moreInfo setHidden:NO];
    }else{
        [self.moreInfo setHidden:YES];
    }
}




//
////获取中文人名的拼音
//
//-(NSMutableArray *)pinyinOfNames:(NSArray *)names
//{
//    NSMutableArray *pinyins = [[NSMutableArray alloc]init];
//    
//    for (NSString *name in names) {
//        NSMutableString *pinyin = [name mutableCopy];
//        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
//        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, NO);
//        
//        [pinyins addObject:[pinyin copy]];
//    }
//    
//    return [pinyins copy];
//}


//
////获取首字母
//-(NSSet *)allFirstLetterInPinyin:(NSArray *)pinyins
//{
//    NSMutableSet *firstLetters = [[NSMutableSet alloc]init];
//    for (NSString *pinyin in pinyins) {
//        NSString*firstCharacter=[pinyin substringToIndex:1];
//        [firstLetters addObject:firstCharacter];
//    }
//    return [firstLetters copy];
//}

//获取每个分组的节头标题

//-(NSArray*)getSectionTitles{
//    NSMutableArray*array=[NSMutableArray array];
//    self.sectionTitles=[NSMutableArray array];
//
//    for (char c = 'A'; c <= 'Z'; c++) {
//        NSString*temp=[NSString stringWithFormat:@"%c",c];
//        if ([self.firstLetter containsObject:temp]) {
//            [array addObject:temp];
//        }
//    }
//    return [array copy];
//}








#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.indexArray count];
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.LetterResultArr objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"contactCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
//    ABRecordRef thisPerson = CFBridgingRetain([self.all_contact objectAtIndex:[indexPath row]]);
//    NSString* name = CFBridgingRelease(ABRecordCopyCompositeName(thisPerson));
//    cell.textLabel.text = name;
//    CFRelease(thisPerson);
    cell.textLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    return cell;
    return cell;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.indexArray[section];
}

#pragma mark - tableView delegate
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return index;
}


#pragma mark dropDownMenu
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((tableView.tag==2015)) {
        if (indexPath.row==0) {
            UITableViewController*addFriendsVC=[UITableViewController alloc];
            addFriendsVC.title=@"添加朋友";
            [self.navigationController pushViewController:addFriendsVC animated:YES];
        }else{
            UITableViewController*postChat=[UITableViewController alloc];
            postChat.title=@"发起群聊";
            [self.navigationController pushViewController:postChat animated:YES];
        }
    }else{
        UITableViewController*friendDetail=[UITableViewController alloc];
        friendDetail.title=@"好友信息";
        [self.navigationController pushViewController:friendDetail animated:YES];
    }
}

#pragma mark --UISearchBarDelegate 协议方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //查询所有
    [self filterContentForSearchText:@""];
}


#pragma mark - UISearchDisplayController Delegate Methods
//当文本内容发生改变时候，向表视图数据源发出重新加载消息
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    //YES情况下表视图可以重新加载
    return YES;
}







#pragma mark - moreInfoViewDelegate
-(void)didSelectedCellAtIndex:(NSUInteger)index withTitle:(NSString *)title
{
    if (index==0) {
        UITableViewController*addFriendsVC=[UITableViewController alloc];
        addFriendsVC.title=title;
        [self.navigationController pushViewController:addFriendsVC animated:YES];
    }else{}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
