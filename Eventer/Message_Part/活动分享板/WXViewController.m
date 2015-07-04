//
//  WXViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "WXViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFPopView.h"
#import "WFActionSheet.h"
#import "databaseService.h"



#define kAdmin @"李老师"
#define AdminId @"4"



@interface WXViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    NSMutableArray *_replyDataSource;
    
    UITableView *mainTable;
    
    UIView *popView;
    
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
    
    
}

@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation WXViewController

-(WXViewController*)init{
    self=[super init];
    self.title=@"活动分享板";
    self.hidesBottomBarWhenPushed=YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"我的分享页" style:UIBarButtonItemStylePlain target:self action:@selector(enterMyPages)];
    return self;
}

-(void)enterMyPages{
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



#pragma mark - 数据源
- (void)configData{
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyDataSource = [[NSMutableArray alloc]init];
    _replyIndex = -1;//代表是直接评论

    NSDictionary*order=[NSDictionary dictionaryWithObject:@"DESC" forKey:@"shareTime"];
    NSDictionary*allshareResults=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbShare" WithCondition:nil orderby:order];


    for (int i=1; i<=[allshareResults count]; i++) {
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
        [_contentDataSource addObject:messagebody];
    }

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self configData];
    
    [self initTableview];
    
    [self loadTextData];
}


#pragma mark -加载数据
- (void)loadTextData{

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
       NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
       
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
             
             WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            
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
        
               [mainTable reloadData];
      
    });

   
}







- (void) initTableview{

    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];

}

//**
// *  ///////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = ym.foldOrNot;
    return TableHeader + kLocationToBottom + ym.replyHeight + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance)+eventImgHeight;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.row;
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];

    return cell;
}

////////////////////////////////////////////////////////////////////

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
     
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];

    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
//    NSLog(@"%f",origin_Y);
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:mainTable rect:targetRect isFavour:ym.hasFavour];
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
    
    [mainTable reloadData];

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
    [mainTable reloadData];
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
    
    [mainTable reloadData];
    
    
    
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
        
        [mainTable reloadData];
        
    }else{
        
    }
    _replyIndex = -1;
}

- (void)dealloc{
    
    NSLog(@"销毁");

}

@end
