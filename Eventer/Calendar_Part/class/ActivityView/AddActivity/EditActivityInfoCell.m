//
//  EditActivityInfoCell.m
//  Calendar
//
//  Created by emma on 15/6/16.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "EditActivityInfoCell.h"

@interface EditActivityInfoCell ()

@end

@implementation EditActivityInfoCell

- (instancetype)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self generateInfoCell];
    
    return self;
}

-(void)generateInfoCell{
    
    CGFloat padding = 20;
    
    UILabel *activitytitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding/2, 80, 20)];
    activitytitleLabel.text = @"名    称:";
    activitytitleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:activitytitleLabel];
    

    UITextField *activityfield = [[UITextField alloc] initWithFrame:CGRectMake(100, padding/2, 200, 30)];
    activityfield.borderStyle=UITextBorderStyleRoundedRect;
  
    [self.contentView addSubview:activityfield];
    
    
    
    UILabel *timetitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(activityfield.frame) + 6, 80, 20)];
    timetitleLabel.text = @"日    期:";
    timetitleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:timetitleLabel];
    
    UITextField *datefield = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(activityfield.frame) + 6, 200, 30)];
    datefield.keyboardType = UIKeyboardTypeDecimalPad;
    datefield.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:datefield];
    
    
    UILabel *addresstitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(datefield.frame) + 6, 80, 20)];
    addresstitleLabel.text = @"地    点:";
    addresstitleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:addresstitleLabel];
    
    UITextField *addressfield = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(datefield.frame) + 6, 200, 30)];
    addressfield.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:addressfield];
    
    UILabel *sponsortitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(addressfield.frame) + 6, 80, 20)];
    sponsortitleLabel.text = @"发起者:";
    sponsortitleLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:sponsortitleLabel];
    
    UITextField *sponsorfield= [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(addressfield.frame) + 6, 200, 30)];
    sponsorfield.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:sponsorfield];
    
    
    self.height = CGRectGetMaxY(sponsorfield.frame) + padding/2;
    
    
}


@end
