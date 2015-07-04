//
//  boardCell.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "boardCell.h"
#define KColor(r,g,b)  [UIColor colorWithHue:r/255.0 saturation:g/255.0 brightness:b/255.0 alpha:1]
#define distance 10;
#define kStatusTableViewCellUserNameFontSize 18
#define kStatusGrayColor KColor(50,50,50)
@interface boardCell()
{
    UILabel *title;
}


@end


@implementation boardCell

-(void)setName:(NSString *)name
{
    title.text=name;
    CGFloat textWidth = self.frame.size.width - 2 * distance;
    CGSize textSize = [title.text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize]} context:nil].size;
    CGRect textRect = CGRectMake(10,10,textSize.width, textSize.height);
    title.frame = textRect;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initsubview];
        // Initialization code
    }
    
    return self;
}
-(void)initsubview
{
    title=[[UILabel alloc]init];
    title.textColor = kStatusGrayColor;
    title.font=[UIFont systemFontOfSize:kStatusTableViewCellUserNameFontSize];
    [self addSubview:title];
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

