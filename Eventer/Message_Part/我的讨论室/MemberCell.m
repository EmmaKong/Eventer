//
//  MemberCell.m
//  BRSliderController
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "MemberCell.h"
#import "ContantHead.h"

@interface MemberCell()
{
    UIImageView * Portrait;//头像
    UIImageView * Identity;//类型
    UILabel * ScreenName;
}
@end
@implementation MemberCell

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
    Portrait = [[UIImageView alloc]init];
    [self addSubview:Portrait];
    //类型
    Identity = [[UIImageView alloc]init];
    [self addSubview:Identity];
    
    //用户
    ScreenName = [[UILabel alloc]init];
    ScreenName.textColor = kStatusGrayColor;
    ScreenName.font = [UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize];
    [self addSubview:ScreenName];

    
}

#pragma mark
- (void)setMember:(member *)member{
    
    CGFloat avatarX = 10,avatarY = 10;
    CGRect avatarRect = CGRectMake(avatarX, avatarY, kStatusTableViewCellAvatarWidth, kStatusTableViewCellAvatarHeight);
    Portrait.image = [UIImage imageNamed:member.Portrait];
    Portrait.frame = avatarRect;
    CALayer*layer=[Portrait layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0.5];
    

    CGRect IdentityRect = CGRectMake(avatarX+kStatusTableViewCellAvatarWidth+5, avatarY+kStatusTableViewCellAvatarHeight+5, kStatusTableViewCellMbTypeWidth, kStatusTableViewCellMbTypeHeight);
    Portrait.image = [UIImage imageNamed:member.Portrait];
    Portrait.frame = avatarRect;
    
    CGFloat userNameX = CGRectGetMaxX(Identity.frame) + kStatusTableViewCellControlSpacing;
    CGFloat userNameY = avatarY;
    CGSize userNameSize = [member.ScreenName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize]}];
    CGRect userNameRect = CGRectMake(userNameX, userNameY, userNameSize.width, userNameSize.height);
    ScreenName.text = member.ScreenName;
    ScreenName.frame = userNameRect;
    
}


@end
