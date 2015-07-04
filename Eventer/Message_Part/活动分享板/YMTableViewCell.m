

#import "YMTableViewCell.h"
#import "WFReplyBody.h"
#import "ContantHead.h"
#import "YMTapGestureRecongnizer.h"
#import "WFHudView.h"






@implementation YMTableViewCell
{
    UIButton *foldBtn;
    YMTextData *tempDate;
    UIImageView *replyImageView;//回复背景块
//    eventBlock *eventImage;
}
//设置头像／人名／简介／展开按钮／回复或点赞
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(marginspace, topmargin, TableHeader, TableHeader)];
        _userHeaderImage.backgroundColor = [UIColor clearColor];
        
        _userHeaderImage.userInteractionEnabled = YES;
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapAvatar:)];
        [_userHeaderImage addGestureRecognizer:tap];

        CALayer *layer = [_userHeaderImage layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:10.0];
        [layer setBorderWidth:1];
        [layer setBorderColor:[[UIColor colorWithRed:63/255.0 green:107/255.0 blue:252/255.0 alpha:1.0] CGColor]];
        [self.contentView addSubview:_userHeaderImage];
        
        
        _shareTime=[[UILabel alloc]initWithFrame:CGRectMake(marginspace, topmargin+TableHeader+10, TableHeader,20 )];
        _shareTime.textAlignment = NSTextAlignmentLeft;
        _shareTime.font = [UIFont systemFontOfSize:13.0];
        _shareTime.textColor = [UIColor colorWithRed:104/255.0 green:109/255.0 blue:248/255.0 alpha:1.0];
        [self.contentView addSubview:_shareTime];
        
        _userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(2*marginspace + TableHeader, 5, screenWidth - 120, TableHeader/2)];
        _userNameLbl.textAlignment = NSTextAlignmentLeft;
        _userNameLbl.font = [UIFont systemFontOfSize:15.0];
        _userNameLbl.textColor = [UIColor colorWithRed:104/255.0 green:109/255.0 blue:248/255.0 alpha:1.0];
        [self.contentView addSubview:_userNameLbl];
        
        

        _ymTextArray = [[NSMutableArray alloc] init];
        _ymShuoshuoArray = [[NSMutableArray alloc] init];
        _ymFavourArray = [[NSMutableArray alloc] init];
        _eventArray=[[NSMutableArray alloc]init];
        
        foldBtn = [UIButton buttonWithType:0];
        [foldBtn setTitle:@"展开" forState:0];
        foldBtn.backgroundColor = [UIColor clearColor];
        foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [foldBtn setTitleColor:[UIColor grayColor] forState:0];
        [foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foldBtn];
        
        replyImageView = [[UIImageView alloc] init];
        
        replyImageView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:replyImageView];


        
        
        _replyBtn = [YMButton buttonWithType:0];
        [_replyBtn setImage:[UIImage imageNamed:@"fw_r2_c2.png"] forState:0];
        [self.contentView addSubview:_replyBtn];
        
        _favourImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _favourImage.image = [UIImage imageNamed:@"zan.png"];
        [self.contentView addSubview:_favourImage];
    }
    return self;
}







- (void)foldText{
    
    if (tempDate.foldOrNot == YES) {
        tempDate.foldOrNot = NO;
        [foldBtn setTitle:@"收起" forState:0];
    }else{
        tempDate.foldOrNot = YES;
        [foldBtn setTitle:@"展开" forState:0];
    }
    
    [_delegate changeFoldState:tempDate onCellRow:self.stamp];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setYMViewWith:(YMTextData *)ymData{
  
    tempDate = ymData;
    
#pragma mark -  //头像 昵称 简介
    _userHeaderImage.image = [UIImage imageNamed:tempDate.messageBody.posterImgstr];
    _userNameLbl.text = tempDate.messageBody.posterName;
    _shareTime.text=tempDate.messageBody.shareTime;

    
    //移除说说view 避免滚动时内容重叠
    for ( int i = 0; i < _ymShuoshuoArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymShuoshuoArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_ymShuoshuoArray removeAllObjects];

  
#pragma mark - // /////////添加说说view

    WFTextView *textView = [[WFTextView alloc] initWithFrame:CGRectMake(commonOffset_X, 10 + TableHeader/2, commonWidth, 0)];
    textView.delegate = self;
    textView.attributedData = ymData.attributedDataShuoshuo;
    textView.isFold = ymData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:ymData.showShuoShuo andNewString:ymData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = ymData.foldOrNot;
    float hhhh = foldOrnot?ymData.shuoshuoHeight:ymData.unFoldShuoHeight;
    
    textView.frame = CGRectMake(commonOffset_X, 10 + TableHeader/2, commonWidth, hhhh);
    
    [_ymShuoshuoArray addObject:textView];


    //按钮

    foldBtn.frame = CGRectMake(commonOffset_X,10+TableHeader/2+hhhh+eventImgHeight, 50, 20 );
    
    if (ymData.islessLimit) {//小于最小限制 隐藏折叠展开按钮
        
        foldBtn.hidden = YES;
    }else{
        foldBtn.hidden = NO;
    }
    
    
    if (tempDate.foldOrNot == YES) {
        
        [foldBtn setTitle:@"展开" forState:0];
    }else{
        
        
        [foldBtn setTitle:@"收起" forState:0];
    }

    
#pragma mark - /////// //分享部分
    //分享块
    for ( int i = 0; i < _eventArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_eventArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_eventArray removeAllObjects];
    
    WFTextView*eventImage=[[WFTextView alloc]initWithFrame:CGRectMake(commonOffset_X, TableHeader/2+10+hhhh,commonWidth, eventImgHeight)];
    eventImage.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self.contentView addSubview:eventImage];
    
    eventImage.userInteractionEnabled = YES;
    YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [eventImage addGestureRecognizer:tap];
    UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
    img.image = [UIImage imageNamed:tempDate.messageBody.posterImgstr];

    NSString*eventTitle=@"测试数据，十五个字显示事件标题，是否能正常显示还需要设置换行";
    CGSize labelSize = {0, 0};
    labelSize = [eventTitle sizeWithFont:[UIFont systemFontOfSize:13]
                     constrainedToSize:CGSizeMake(commonWidth-55, 40)
                         lineBreakMode:UILineBreakModeWordWrap];
    UILabel*eventName=[[UILabel alloc]initWithFrame:CGRectMake(50, 5, labelSize.width, labelSize.height)];

    
    eventName.numberOfLines=0;
    eventName.lineBreakMode=UILineBreakModeWordWrap;

    eventName.text=eventTitle;
    eventName.font = [UIFont systemFontOfSize:13.0];
    eventName.textColor = [UIColor blackColor];
    [eventImage addSubview:eventName];
    
    
    [eventImage addSubview:img];
    eventImage.delegate=self;
    [_eventArray addObject:eventImage];

    
    
    
#pragma mark - /////点赞部分
    //移除点赞view 避免滚动时内容重叠
    for ( int i = 0; i < _ymFavourArray.count; i ++) {
        WFTextView * imageV = (WFTextView *)[_ymFavourArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_ymFavourArray removeAllObjects];

    
    float origin_Y = 10;
    float backView_Y = 0;
    float backView_H = 0;
    
    
    
    WFTextView *favourView = [[WFTextView alloc] initWithFrame:CGRectMake(commonOffset_X+28, TableHeader/2 + 15 + hhhh + kReplyBtnDistance, commonWidth-28, 0)];
    favourView.delegate = self;
    favourView.attributedData = ymData.attributedDataFavour;
    favourView.isDraw = YES;
    favourView.isFold = NO;
    favourView.canClickAll = NO;
    favourView.textColor = [UIColor redColor];
    [favourView setOldString:ymData.showFavour andNewString:ymData.completionFavour];
    favourView.frame = CGRectMake(commonOffset_X+28,TableHeader/2 + 15 + origin_Y + hhhh + kReplyBtnDistance+eventImgHeight,commonWidth-28, ymData.favourHeight);
    [self.contentView addSubview:favourView];
    backView_H += ((ymData.favourHeight == 0)?(-kReply_FavourDistance):ymData.favourHeight);
    [_ymFavourArray addObject:favourView];

//点赞图片的位置
    _favourImage.frame = CGRectMake(commonOffset_X, favourView.frame.origin.y, (ymData.favourHeight == 0)?0:20,(ymData.favourHeight == 0)?0:20);
    
    
#pragma mark - ///// //最下方回复部分
    for (int i = 0; i < [_ymTextArray count]; i++) {
        
        WFTextView * ymTextView = (WFTextView *)[_ymTextArray objectAtIndex:i];
        if (ymTextView.superview) {
            [ymTextView removeFromSuperview];
            //  NSLog(@"here");
            
        }
        
    }
    
    [_ymTextArray removeAllObjects];
  
    
    for (int i = 0; i < ymData.replyDataSource.count; i ++ ) {
        
        WFTextView *_ilcoreText = [[WFTextView alloc] initWithFrame:CGRectMake(commonOffset_X,TableHeader + 10 + origin_Y + hhhh + kReplyBtnDistance + ymData.favourHeight + (ymData.favourHeight == 0?0:kReply_FavourDistance)+eventImgHeight, commonWidth, 0)];
        
        if (i == 0) {
            backView_Y = TableHeader/2 + 10 + origin_Y + hhhh ;
        }
        
        _ilcoreText.delegate = self;
        _ilcoreText.replyIndex = i;
        _ilcoreText.isFold = NO;
        _ilcoreText.attributedData = [ymData.attributedDataReply objectAtIndex:i];
        
        
        WFReplyBody *body = (WFReplyBody *)[ymData.replyDataSource objectAtIndex:i];
        
        NSString *matchString;
        
        if ([body.repliedUser isEqualToString:@""]) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
            
        }else{
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
            
        }
        
        [_ilcoreText setOldString:matchString andNewString:[ymData.completionReplySource objectAtIndex:i]];
        
        _ilcoreText.frame = CGRectMake(commonOffset_X,TableHeader/2 + 10 + origin_Y + hhhh + kReplyBtnDistance + ymData.favourHeight + (ymData.favourHeight == 0?0:kReply_FavourDistance)+eventImgHeight,commonWidth, [_ilcoreText getTextHeight]);
        [self.contentView addSubview:_ilcoreText];
        origin_Y += [_ilcoreText getTextHeight] + 5 ;
        
        backView_H += _ilcoreText.frame.size.height;
        
        [_ymTextArray addObject:_ilcoreText];
    }
    
    backView_H += (ymData.replyDataSource.count - 1)*5;
    
    
    
    if (ymData.replyDataSource.count == 0) {//没回复的时候
        
        replyImageView.frame = CGRectMake(commonOffset_X, backView_Y + kReplyBtnDistance+eventImgHeight, 0, 0);
        _replyBtn.frame = CGRectMake(screenWidth - marginspace - 40 + 6,TableHeader/2 + 10 + hhhh+eventImgHeight, 40 , 18);

        
    }else{
        
        replyImageView.frame = CGRectMake(commonOffset_X, backView_Y + kReplyBtnDistance+eventImgHeight,commonWidth, backView_H + 20 - 8);//微调
        
        _replyBtn.frame = CGRectMake(screenWidth - marginspace - 40 + 6,10+TableHeader/2+hhhh+eventImgHeight, 40, 18);
        
        
    }
    
    
}

#pragma mark - ilcoreTextDelegate
- (void)clickMyself:(NSString *)clickString{
    
    //延迟调用下  可去掉 下同
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:clickString message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
        
    });
    
    
}


- (void)longClickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
  
    [_delegate longClickRichText:_stamp replyIndex:index];
      
}


- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index{
    
    if ([clickString isEqualToString:@""]) {
       //reply
        //NSLog(@"reply");
        [_delegate clickRichText:_stamp replyIndex:index];
    }else{
       //do nothing
        [WFHudView showMsg:clickString inView:nil];
    }
    
}

#pragma mark - 点击action
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    
//    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
    [_delegate showEventImagewithEventId:tapGes.view.tag];
    
}

-(void)tapAvatar:(YMTapGestureRecongnizer *)tapGes
{
    NSLog(@"tapAvatar!");
    [_delegate showUserInformationbyUserId:tapGes.view.tag];
}

@end
