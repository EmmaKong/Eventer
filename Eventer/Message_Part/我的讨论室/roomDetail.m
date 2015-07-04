//
//  roomDetail.m
//  BRSliderController
//
//  Created by admin on 15/4/29.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "roomDetail.h"
#import "roomCell.h"
#import "eventIntroCell.h"
#import "YMReplyInputView.h"
#import "DiscussionRoomItemCell.h"
#import "databaseService.h"
#import "WFHudView.h"
#import "WFPopView.h"
#import "WFTextView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "ContantHead.h"
#import "YMTextData.h"
#import "YMShowImageView.h"
#import "WFActionSheet.h"
#import "AllMemberViewController.h"
#define kAdmin @"李老师"
#define AdminId @"4"

@interface roomDetail ()<DisscussRoomcellDelegate,InputDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@end

@implementation roomDetail{
    NSMutableArray*_tableDataSource;//显示数据
    NSMutableArray*_FloorDataSource;//层主消息
    NSMutableArray*_replyDataSource;//回复层主的消息
    UIView *popView;
    YMReplyInputView *replyView ;
    NSInteger _replyIndex;
}

-(roomDetail*)init{
    self=[super init];
    self.hidesBottomBarWhenPushed=YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"主题";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"讨论成员" style:UIBarButtonItemStylePlain target:self action:@selector(ShowAllMembers)];
    UIBarButtonItem *backbutton= self.navigationItem.backBarButtonItem;
    backbutton.title=@"返回";
    [self configData];
    [self loadTextData];
}

-(void)ShowAllMembers{
    AllMemberViewController*allMember=[AllMemberViewController alloc];
    allMember.roomId=self.roomId;
    [self.navigationController pushViewController:allMember animated:YES];
}

#pragma mark - 数据源
- (void)configData{
    _tableDataSource = [[NSMutableArray alloc] init];
    _FloorDataSource = [[NSMutableArray alloc] init];
    _replyDataSource = [[NSMutableArray alloc]init];
    _replyIndex = -1;//代表是直接评论
    
    NSDictionary*order=[NSDictionary dictionaryWithObject:@"DESC" forKey:@"shareTime"];
    NSDictionary*allshareResults=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbShare" WithCondition:nil orderby:order];
    NSInteger i;
    
    for (i=1; i<=[allshareResults count]; i++) {
        WFMessageBody*messagebody=[[WFMessageBody alloc]init];
        NSDictionary*shareItem=[allshareResults objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
        
        messagebody.shareID=[shareItem objectForKey:@"shareId"];
        messagebody.posterContent=[shareItem objectForKey:@"shareContent"];
        messagebody.shareTime=[shareItem objectForKey:@"shareTime"];
        NSLog(@"%@,%@",messagebody.posterContent,[shareItem objectForKey:@"Talker"]);
        
        //取出用户信息
        
        NSDictionary*User=[self getUserInfoWithshareItem:shareItem byNameKey:@"Talker"];
        messagebody.posterName=[User objectForKey:@"NickName"];
        messagebody.posterImgstr=[User objectForKey:@"AvatarIcon"];
        messagebody.isFavour=NO;
        messagebody.posterFavour=[NSMutableArray arrayWithObjects:nil];
        
        
        
        //取出事件信息
        NSDictionary*EventCondition=[NSDictionary dictionaryWithObject:[shareItem objectForKey:@"ActivityId"] forKey:@"zactivityId"];
        NSDictionary*activityResults=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbEvent" WithCondition:EventCondition];
        NSDictionary*activity=[activityResults allValues][0];
        messagebody.posterEventURL=[activity objectForKey:@"zurl"];
        messagebody.posterEventImg=[activity objectForKey:@"zsourcricon"];
        messagebody.posterEventIntro=[activity objectForKey:@"ztitle"];
        
        
        //取出分享的评论信息
        NSDictionary*commentCondition=[NSDictionary dictionaryWithObject:[shareItem objectForKey:@"shareId"] forKey:@"shareId"];
        NSDictionary*replyOrder=[NSDictionary dictionaryWithObject:@"ASC" forKey:@"replyTime"];
        NSDictionary*shareCommentResults=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbShareComment" WithCondition:commentCondition orderby:replyOrder];
        if ([shareCommentResults count]!=0) {
            NSInteger j;
            for (j=1; j<=[shareCommentResults count]; j++) {
                WFReplyBody*replybody=[[WFReplyBody alloc]init];
                NSDictionary*commentItem=[shareCommentResults objectForKey:[NSString stringWithFormat:@"%ld",(long)j]];
                replybody.replyID=[commentItem objectForKey:@"replyId"];
                replybody.replyTime=[commentItem objectForKey:@"replyTime"];
                NSDictionary*reply=[self getUserInfoWithshareItem:commentItem byNameKey:@"reply"];
                if (reply==nil) {
                    replybody.replyUser=@"";
                    replybody.replyUserId=@"";
                }else{
                    replybody.replyUser=[reply objectForKey:@"NickName"];
                    replybody.replyUserId=[reply objectForKey:@"UserId"];
                }
                NSDictionary*replied=[self getUserInfoWithshareItem:commentItem byNameKey:@"replied"];
                if (replied==nil) {
                    replybody.repliedUser=@"";
                    replybody.repliedUserId=@"";
                }else{
                    replybody.repliedUser=[replied objectForKey:@"NickName"];
                    replybody.repliedUserId=[replied objectForKey:@"UserId"];
                }
                replybody.replyInfo=[commentItem objectForKey:@"replyContent"];
                [_replyDataSource addObject:replybody];
                messagebody.posterReplies=[NSMutableArray arrayWithArray:_replyDataSource];
            }
        }else{
            messagebody.posterReplies=[NSMutableArray arrayWithObjects:nil];
        }
        [_replyDataSource removeAllObjects];
        [_FloorDataSource addObject:messagebody];
    }
    
}


-(NSDictionary*)getUserInfoWithshareItem:(NSDictionary*)shareitem byNameKey:(NSString*)Uid{
    
    if ([[shareitem objectForKey:Uid]isEqualToString:@""]) {
        return nil;
    }else{
        NSDictionary*UserCondition=[NSDictionary dictionaryWithObject:[shareitem objectForKey:Uid] forKey:@"UserId"];
        NSDictionary*UserResults=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbUser" WithCondition:UserCondition];
        NSDictionary*User=[UserResults allValues][0];
        return User;
    }
    
}

#pragma mark -加载数据
- (void)loadTextData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
        
        for (int i = 0 ; i < _FloorDataSource.count; i ++) {
            
            WFMessageBody *messBody = [_FloorDataSource objectAtIndex:i];
            
            YMTextData *ymData = [[YMTextData alloc] init ];
            ymData.messageBody = messBody;
            
            [ymDataArray addObject:ymData];
            
        }
        [self calculateHeight:ymDataArray];
        
    });
}



#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{
    
    
    NSDate* tmpStartData = [NSDate date];
    
    for (YMTextData *ymData in dataArray) {
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width-ShowImage_H-offSet_X*2 withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width-ShowImage_H-offSet_X*2 withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width-ShowImage_H-offSet_X*2];
        
        ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width-ShowImage_H-offSet_X*2];
        
        [_tableDataSource addObject:ymData];
        
    }
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section==0) {
        return 1;
    }else{
        return [_tableDataSource count];
    }
}
-(UITableView *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([indexPath section]==0) {
        static NSString *cellindentifier=@"room";
        eventIntroCell *cell=[tableView dequeueReusableCellWithIdentifier:cellindentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"eventIntroCell" owner:self options:nil] lastObject];
        }
        cell.eventImg.image=[UIImage imageNamed:self.roomIcon];
        cell.title.text=self.roomName;
//        NSLog(@"roomid%@",self.roomId);
        NSDictionary*condition=[NSDictionary dictionaryWithObject:self.roomId forKey:@"DiscussionRoomId"];
        NSDictionary*isMember=[[[databaseService shareddatabaseService]get:@"isMember" FromTable:@"dbEventRoomList" WithCondition:condition]allValues][0];
        cell.isMember=[isMember objectForKey:@"isMember"];
        cell.DiscussionRoomId=self.roomId;
        if([cell.isMember isEqualToString:@"yes"]){
            cell.join.titleLabel.text=@"退出";
            [cell.join setTitle:@"退出" forState:UIControlStateNormal];
        }else{
            cell.join.titleLabel.text=@"加入";
            [cell.join setTitle:@"加入" forState:UIControlStateNormal];
        }
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"ILTableViewCell";
        
        DiscussionRoomItemCell *cell = (DiscussionRoomItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DiscussionRoomItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.stamp = indexPath.row;
        cell.replyBtn.appendIndexPath = indexPath;
        [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate = self;
        [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([indexPath section]==0) {
        
        return 160;
    }else{
        YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
        BOOL unfold = ym.foldOrNot;
        return TableHeader + kLocationToBottom + ym.replyHeight + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance)+eventImgHeight;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



////////////////////////////////////////////////////////////////////

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
    
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:sender.appendIndexPath];
    
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    //    NSLog(@"%f",origin_Y);
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:self.tableView rect:targetRect isFavour:ym.hasFavour];
}



- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        WS(ws);
        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    
                    [ws addLike];
                    break;
                case WFOperationTypeReply:
                    [ws replyMessage: nil];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

#pragma mark - 赞
- (void)addLike{
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.row];
    WFMessageBody *m = ymData.messageBody;
    if (m.isFavour == YES) {//此时该取消赞
        [m.posterFavour removeObject:kAdmin];
        m.isFavour = NO;
    }else{
        [m.posterFavour addObject:kAdmin];
        m.isFavour = YES;
    }
    ymData.messageBody = m;
    
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    
    
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:ymData];
    
    [self.tableView reloadData];
    
}


#pragma mark - 真の评论
- (void)replyMessage:(YMButton *)sender{
    
    if (replyView) {
        return;
    }
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = _selectedIndexPath.row;
    [self.view addSubview:replyView];
    
}


#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.operationView dismiss];
    
}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [self.tableView reloadData];
}

#pragma mark - 图片点击事件回调
//- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
//
//    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
//    maskview.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:maskview];
//
//    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
//    [ymImageV show:maskview didFinish:^(){
//
//        [UIView animateWithDuration:0.5f animations:^{
//
//            ymImageV.alpha = 0.0f;
//            maskview.alpha = 0.0f;
//
//        } completion:^(BOOL finished) {
//
//            [ymImageV removeFromSuperview];
//            [maskview removeFromSuperview];
//        }];
//
//    }];
//
//}
#pragma mark - 活动点击事件回调
-(void)showEventImagewithEventId:(NSInteger)clickTag
{
    NSLog(@"click event!");
    UITableViewController*eventDetail=[UITableViewController alloc];
    [self.navigationController pushViewController:eventDetail animated:NO];
}


-(void)showUserInformationbyUserId:(NSInteger)clickTag
{
    NSLog(@"click avatar!");
    UITableViewController*userDetail=[UITableViewController alloc];
    [self.navigationController pushViewController:userDetail animated:NO];
    
}

#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    if (replyIndex==-1) {
        
    }else{
        WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
        
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = b.replyInfo;
    }
    
}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    NSLog(@"%ld,%ld",(long)index,(long)replyIndex);
    if (replyIndex==-1) {
        
    }else
    {
        WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
        if ([b.replyUser isEqualToString:kAdmin]) {
            WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            actionSheet.actionIndex = index;
            
            
            [actionSheet showInView:self.view];
            
            
            
        }else{
            //回复
            if (replyView) {
                return;
            }
            replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
            replyView.delegate = self;
            replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
            replyView.replyTag = index;
            [self.view addSubview:replyView];
        }
    }
}







#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式
    NSString *currentTimeString = [dateFormat stringFromDate:[NSDate date]];
    
    YMTextData *ymData = nil;
    
    if (_replyIndex == -1) {
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.replyUserId= AdminId;
        body.repliedUser = @"";
        body.repliedUserId=@"";
        body.replyInfo = replyText;
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        NSDictionary*bodyDic=[NSDictionary dictionaryWithObjectsAndKeys:m.shareID,@"shareId",body.replyUserId,@"reply",body.repliedUserId,@"replied",body.replyInfo,@"replyContent",currentTimeString,@"replyTime",nil];
        [[databaseService shareddatabaseService]insert:bodyDic toTable:@"dbShareComment"];
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.replyUserId=AdminId;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.repliedUserId=[(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUserId];
        body.replyInfo = replyText;
        
        NSDictionary*bodyDic=[NSDictionary dictionaryWithObjectsAndKeys:m.shareID,@"shareId",body.replyUserId,@"reply",body.repliedUserId,@"replied",body.replyInfo,@"replyContent",currentTimeString,@"replyTime",nil];
        
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        [[databaseService shareddatabaseService]insert:bodyDic toTable:@"dbShareComment"];
        
    }
    
    
    
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    [self.tableView reloadData];
    
    
    
}

- (void)destorySelf{
    
    //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;
    
}

- (void)actionSheet:(WFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //delete
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
        WFMessageBody *m = ymData.messageBody;
        NSLog(@"%ld",(long)_replyIndex);
        NSString*replyTime=[(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyTime];
        NSDictionary*deleteCondition=[NSDictionary dictionaryWithObject:replyTime forKey:@"replyTime"];
        [[databaseService shareddatabaseService]deleteFrom:@"dbShareComment" WithCondition:deleteCondition];
        [m.posterReplies removeObjectAtIndex:_replyIndex];
        ymData.messageBody = m;
        [ymData.completionReplySource removeAllObjects];
        [ymData.attributedDataReply removeAllObjects];
        
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        [_tableDataSource replaceObjectAtIndex:actionSheet.actionIndex withObject:ymData];
        
        [self.tableView reloadData];
        
    }else{
        
    }
    _replyIndex = -1;
}

- (void)dealloc{
    
    NSLog(@"销毁");
    
}

#pragma mark 代理方法
//-(void)updateIsMemberFlagInDatabaseWith:(NSString*)isMenmber{
//    NSDictionary*condition=[NSDictionary dictionaryWithObject:self.roomId forKey:@"DiscussionRoomId"];
//    NSDictionary*change=[NSDictionary dictionaryWithObject:isMenmber forKey:@"isMember"];
//    [[databaseService shareddatabaseService]updateTable:@"dbEventRoomList" WithChanges:change AndConditions:condition];
//
//}



@end
