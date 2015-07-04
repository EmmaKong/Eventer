//
//  eventIntroCell.m
//  BRSliderController
//
//  Created by admin on 15/5/29.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "eventIntroCell.h"
#import "databaseService.h"

@implementation eventIntroCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)join:(id)sender {

    if([self.isMember isEqualToString:@"yes"]){
        self.isMember=@"no";
        [self.delegate updateIsMemberFlagInDatabaseWith:self.isMember];
        self.join.titleLabel.text=@"加入";
        [self.join setTitle:@"加入" forState:UIControlStateNormal];
        [self updateIsMemberFlagInDatabaseWith:self.isMember];
    }
    else{
        self.isMember=@"yes";
        [self.delegate updateIsMemberFlagInDatabaseWith:self.isMember];
        self.join.titleLabel.text=@"退出";
        [self.join setTitle:@"退出" forState:UIControlStateNormal];
        [self updateIsMemberFlagInDatabaseWith:self.isMember];
    }
}

- (IBAction)detail:(id)sender {
}

- (IBAction)addrange:(id)sender {

}

-(void)updateIsMemberFlagInDatabaseWith:(NSString*)isMenmber{
    NSDictionary*condition=[NSDictionary dictionaryWithObject:self.DiscussionRoomId forKey:@"DiscussionRoomId"];
    NSDictionary*change=[NSDictionary dictionaryWithObject:isMenmber forKey:@"isMember"];
    [[databaseService shareddatabaseService]updateTable:@"dbEventRoomList" WithChanges:change AndConditions:condition];
    
}



@end
