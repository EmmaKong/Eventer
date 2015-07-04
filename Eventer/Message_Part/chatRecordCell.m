//
//  chatRecordCell.m
//  BRSliderController
//
//  Created by admin on 15/5/27.
//  Copyright (c) 2015年 BR. All rights reserved.
//




#import "chatRecordCell.h"
#import "chatRecord.h"



#define KColor(r,g,b)  [UIColor colorWithHue:r/255.0 saturation:g/255.0 brightness:b/255.0 alpha:1]
#define kStatusTableViewCellControlSpacing 10//控件间距
#define kStatusTableViewCellBackgroundColor KColor(251,251,251)
#define kStatusGrayColor KColor(50,50,50)
#define kStatusLightGrayColor KColor(120,120,120)

#define kStatusTableViewCellAvatarWidth 40 //头像宽度
#define kStatusTableViewCellAvatarHeight kStatusTableViewCellAvatarWidth
#define kStatusTableViewCellUserNameFontSize 14
#define kStatusTableViewCellMbTypeWidth 13 //会员图标宽度
#define kStatusTableViewCellMbTypeHeight kStatusTableViewCellMbTypeWidth
#define kStatusTableViewCellCreateAtFontSize 12
#define kStatusTableViewCellTextFontSize 14

@interface chatRecordCell()
{
    UIImageView * avatar;//头像
    //    UIImageView * _mbType;//会员类型
    UILabel * name;
    UILabel * lastMsg;
    UILabel * time;
    
}

@end

@implementation chatRecordCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

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
    avatar = [[UIImageView alloc]init];
    [self addSubview:avatar];
    
    //用户
    name = [[UILabel alloc]init];
    name.textColor = kStatusGrayColor;
    name.font = [UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize];
    [self addSubview:name];
    
    //    //会员类型
    //    _mbType = [[UIImageView alloc]init];
    //    [self addSubview:_mbType];
    
    //日期
    time = [[UILabel alloc]init];
    time.textColor = kStatusLightGrayColor;
    time.font = [UIFont systemFontOfSize:kStatusTableViewCellCreateAtFontSize];
    [self addSubview:time];
    
    //内容
    lastMsg= [[UILabel alloc]init];
    lastMsg.textColor = kStatusGrayColor;
    lastMsg.font = [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
    lastMsg.numberOfLines = 0;
    [self addSubview:lastMsg];
    
}
//1）.对于单行文本数据的显示调用+ (UIFont *)systemFontOfSize:(CGFloat)fontSize;方法来得到文本宽度和高度。
//2）.对于多行文本数据的显示调用- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context ;方法来得到文本宽度和高度；同时注意在此之前需要设置文本控件的numberOfLines属性为0。
#pragma mark
- (void)setChatRecord:(chatRecord *)chatRecord{
    
    CGFloat avatarX = 10,avatarY = 10;
    CGRect avatarRect = CGRectMake(avatarX, avatarY, kStatusTableViewCellAvatarWidth, kStatusTableViewCellAvatarHeight);
    avatar.image = [UIImage imageNamed:chatRecord.avatar];
    avatar.frame = avatarRect;
    
    CGFloat userNameX = CGRectGetMaxX(avatar.frame) + kStatusTableViewCellControlSpacing;
    CGFloat userNameY = avatarY;
    CGSize userNameSize = [chatRecord.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize]}];
    CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    name.text = chatRecord.name;
    name.frame = userNameRect;
    
    //    CGFloat mbTypeX = CGRectGetMaxX(_userName.frame) + kStatusTableViewCellControlSpacing;
    //    CGFloat mbTypeY = avatarY;
    //    CGRect mbTypeRect = CGRectMake(mbTypeX, mbTypeY, kStatusTableViewCellMbTypeWidth, kStatusTableViewCellMbTypeHeight);
    //    _mbType.image = [UIImage imageNamed:status.mbtype];
    //    _mbType.frame = mbTypeRect;
    
    
    
    //活动时间的位置设置
    CGSize createAtSize = [chatRecord.time sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellCreateAtFontSize]}];
    CGFloat createAtX = 330;
    CGFloat createAtY = userNameY;
    CGRect createAtRect = CGRectMake(createAtX, createAtY, createAtSize.width, createAtSize.height);
    time.text = chatRecord.time;
    time.frame = createAtRect;
    
    
    CGFloat textWidth = self.frame.size.width - 2 * kStatusTableViewCellControlSpacing;
    CGSize textSize = [chatRecord.lastMsg boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
    CGFloat textX = userNameX;
    CGFloat textY = CGRectGetMaxY(avatar.frame) -textSize.height;
    CGRect textRect = CGRectMake(textX, textY, textSize.width, textSize.height);
    lastMsg.text = chatRecord.lastMsg;
    lastMsg.frame = textRect;
    
    _height = CGRectGetMaxY(lastMsg.frame) + kStatusTableViewCellControlSpacing;
    
}




@end
