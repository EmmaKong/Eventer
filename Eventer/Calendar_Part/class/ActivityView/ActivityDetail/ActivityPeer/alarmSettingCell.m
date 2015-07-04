//
//  alarmSettingCell.m
//  Eventer
//
//  Created by admin on 15/6/25.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "alarmSettingCell.h"

@implementation alarmSettingCell

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
    
    
}

@end
