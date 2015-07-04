//
//  eventCell.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "eventCell.h"
#import "event.h"
#import "ContantHead.h"
#import "databaseService.h"


@interface eventCell()
{
    UIButton * save;
    UIImageView * sourceicon;//头像
    //    UIImageView * _mbType;//会员类型
    UILabel * sponsor;
    UILabel * title;
    UILabel * time;
    
}

@end
@implementation eventCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        
    }
    return self;
}

#pragma mark 初始化视图
- (void)initSubview{
    //头像控件
    sourceicon = [[UIImageView alloc]init];
    [self addSubview:sourceicon];
    
    //用户
    sponsor = [[UILabel alloc]init];
    sponsor.textColor = kStatusGrayColor;
    sponsor.font = [UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize];
    [self addSubview:sponsor];
    
    //    //会员类型
    //    _mbType = [[UIImageView alloc]init];
    //    [self addSubview:_mbType];
    
    //日期
    time = [[UILabel alloc]init];
    time.textColor = kStatusLightGrayColor;
    time.font = [UIFont systemFontOfSize:kStatusTableViewCellCreateAtFontSize];
    [self addSubview:time];
    
    //内容
    title= [[UILabel alloc]init];
    title.textColor = kStatusGrayColor;
    title.font = [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
    title.numberOfLines = 0;
    [self addSubview:title];
    
    save=[UIButton buttonWithType:UIButtonTypeCustom];
    save.userInteractionEnabled=YES;
    save.adjustsImageWhenDisabled=YES;
    [save addTarget:self action:@selector(saveEvent) forControlEvents:UIControlEventTouchUpInside];
    UIImage*img01=[UIImage imageNamed:@"03@2x.png"];
    UIImage*img02=[UIImage imageNamed:@"touxiang1.png"];
    [save setImage:img01 forState:UIControlStateNormal];
    [save setImage:img02 forState:UIControlStateHighlighted];
    [self addSubview:save];
    
}
//1）.对于单行文本数据的显示调用+ (UIFont *)systemFontOfSize:(CGFloat)fontSize;方法来得到文本宽度和高度。
//2）.对于多行文本数据的显示调用- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context ;方法来得到文本宽度和高度；同时注意在此之前需要设置文本控件的numberOfLines属性为0。
#pragma mark
- (void)setEvent:(event *)event{
    
    CGFloat avatarX = 10,avatarY = 10;
    CGRect avatarRect = CGRectMake(avatarX, avatarY, kStatusTableViewCellAvatarWidth, kStatusTableViewCellAvatarHeight);
    sourceicon.image = [UIImage imageNamed:event.zsourceicon];
    sourceicon.frame = avatarRect;
    
    CGFloat userNameX = CGRectGetMaxX(sourceicon.frame) + kStatusTableViewCellControlSpacing;
    CGFloat userNameY = avatarY;
    CGSize userNameSize = [event.zmoperator sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize]}];
    CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    sponsor.text = event.zmoperator;
    sponsor.frame = userNameRect;
    
    //    CGFloat mbTypeX = CGRectGetMaxX(_userName.frame) + kStatusTableViewCellControlSpacing;
    //    CGFloat mbTypeY = avatarY;
    //    CGRect mbTypeRect = CGRectMake(mbTypeX, mbTypeY, kStatusTableViewCellMbTypeWidth, kStatusTableViewCellMbTypeHeight);
    //    _mbType.image = [UIImage imageNamed:status.mbtype];
    //    _mbType.frame = mbTypeRect;
    
    
    
    //活动时间的位置设置
    CGSize createAtSize = [event.zpubtime sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellCreateAtFontSize]}];
    CGFloat createAtX = 330;
    CGFloat createAtY = userNameY;
    CGRect createAtRect = CGRectMake(createAtX, createAtY, createAtSize.width, createAtSize.height);
    time.text = event.zpubtime;
    time.frame = createAtRect;
    
    save.frame=CGRectMake(createAtX, CGRectGetMaxY(createAtRect)+5, 20, 20);

    
    CGFloat textWidth = self.frame.size.width - 2 * kStatusTableViewCellControlSpacing;
    CGSize textSize = [event.ztitle boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
    CGFloat textX = userNameX;
    CGFloat textY = CGRectGetMaxY(sourceicon.frame) -textSize.height;
    CGRect textRect = CGRectMake(textX, textY, textSize.width, textSize.height);
    title.text = event.ztitle;
    title.frame = textRect;
    
    

    
    _height = CGRectGetMaxY(title.frame) + kStatusTableViewCellControlSpacing;
    
}

-(void)saveEvent{
    NSLog(@"%@",self.event.zpubtime);
    NSDictionary*schedule=[NSDictionary dictionaryWithObjectsAndKeys:self.event.ztitle,@"EventName",@"1",@"Status",self.event.zoperateTime,@"Time",@"school",@"Place",@"0",@"ShouldRemind",@"null",@"RemindTime",@"null",@"Description",@"1",@"Duration",@"01,02,03",@"Companion",@"null",@"frequency", nil];
    [[databaseService shareddatabaseService]insert:schedule toTable:@"dbSchedule"];
}



@end

