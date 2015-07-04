//
//  roomCell.m
//  BRSliderController
//
//  Created by admin on 15/4/29.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "roomCell.h"
#import "roomData.h"
#import "ContantHead.h"
@interface roomCell()
{
    UIImageView * roomIcon;//头像
    //    UIImageView * _mbType;//会员类型
    UILabel * roomName;
    UILabel * roomIntro;
    UILabel * lastModifyTime;
    
}

@end

@implementation roomCell

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
- (void)initSubview{
    //头像控件
    roomIcon = [[UIImageView alloc]init];
    [self addSubview:roomIcon];
    
    //用户
    roomName = [[UILabel alloc]init];
    roomName.textColor = kStatusGrayColor;
    roomName.font = [UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize];
    [self addSubview:roomName];
    
    
    //日期
    lastModifyTime = [[UILabel alloc]init];
    lastModifyTime.textColor = kStatusLightGrayColor;
    lastModifyTime.font = [UIFont systemFontOfSize:kStatusTableViewCellCreateAtFontSize];
    [self addSubview:lastModifyTime];
    
    //内容
    roomIntro= [[UILabel alloc]init];
    roomIntro.textColor = kStatusGrayColor;
    roomIntro.font = [UIFont systemFontOfSize:kStatusTableViewCellTextFontSize];
    roomIntro.numberOfLines = 0;
    [self addSubview:roomIntro];
    
}
//1）.对于单行文本数据的显示调用+ (UIFont *)systemFontOfSize:(CGFloat)fontSize;方法来得到文本宽度和高度。
//2）.对于多行文本数据的显示调用- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context ;方法来得到文本宽度和高度；同时注意在此之前需要设置文本控件的numberOfLines属性为0。
#pragma mark
- (void)setRoomdata:(roomData *)roomdata{
    
    CGFloat avatarX = 10,avatarY = 10;
    CGRect avatarRect = CGRectMake(avatarX, avatarY, kStatusTableViewCellAvatarWidth, kStatusTableViewCellAvatarHeight);
    roomIcon.image = [UIImage imageNamed:roomdata.roomIcon];
    roomIcon.frame = avatarRect;
    
    CGFloat userNameX = CGRectGetMaxX(roomIcon.frame) + kStatusTableViewCellControlSpacing;
    CGFloat userNameY = avatarY;
    CGSize userNameSize = [roomdata.roomName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize]}];
    CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    roomName.text = roomdata.roomName;
    roomName.frame = userNameRect;
    
    //    CGFloat mbTypeX = CGRectGetMaxX(_userName.frame) + kStatusTableViewCellControlSpacing;
    //    CGFloat mbTypeY = avatarY;
    //    CGRect mbTypeRect = CGRectMake(mbTypeX, mbTypeY, kStatusTableViewCellMbTypeWidth, kStatusTableViewCellMbTypeHeight);
    //    _mbType.image = [UIImage imageNamed:status.mbtype];
    //    _mbType.frame = mbTypeRect;
    
    
    
    //活动时间的位置设置
    CGSize createAtSize = [roomdata.lastModifyTime sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellCreateAtFontSize]}];
    CGFloat createAtX = 330;
    CGFloat createAtY = userNameY;
    CGRect createAtRect = CGRectMake(createAtX, createAtY, createAtSize.width, createAtSize.height);
    lastModifyTime.text = roomdata.lastModifyTime;
    lastModifyTime.frame = createAtRect;
    
    
    CGFloat textWidth = self.frame.size.width - 2 * kStatusTableViewCellControlSpacing;
    CGSize textSize = [roomdata.roomIntro boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellTextFontSize]} context:nil].size;
    CGFloat textX = userNameX;
    CGFloat textY = CGRectGetMaxY(roomIcon.frame) -textSize.height;
    CGRect textRect = CGRectMake(textX, textY, textSize.width, textSize.height);
    roomIntro.text = roomdata.roomIntro;
    roomIntro.frame = textRect;
    
    _height = CGRectGetMaxY(roomIntro.frame) + kStatusTableViewCellControlSpacing;
    
}

@end
