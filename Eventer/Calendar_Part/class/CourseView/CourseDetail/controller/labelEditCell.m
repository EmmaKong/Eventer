//
//  labelEditCell.m
//  Eventer
//
//  Created by admin on 15/6/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "labelEditCell.h"

@implementation labelEditCell{
    UILabel*titleLabel;
    UITextField*Textfield;
}


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
-(void)initSubview{
    CGFloat padding = 20;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding/2, 50, 20)];
    titleLabel.text = self.cellTitle;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    

    Textfield=[[UITextField alloc]initWithFrame:CGRectMake(100, padding/2, 150, 20)];
    Textfield.text=self.cellContant;
    Textfield.font=[UIFont systemFontOfSize:15];
    Textfield.layer.borderColor=(__bridge CGColorRef)([UIColor clearColor]);
    [self.contentView addSubview:Textfield];

}

-(void)setCellTitle:(NSString *)cellTitle{
        titleLabel.text = cellTitle;
}
-(void)setCellContant:(NSString *)cellContant{
    Textfield.text=cellContant;
}

@end
