//
//  eventIntroCell.h
//  BRSliderController
//
//  Created by admin on 15/5/29.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol updateDatabaseDelegate<NSObject>
-(void)updateIsMemberFlagInDatabaseWith:(NSString*)isMenmber;

@end

@interface eventIntroCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *join;
@property (weak, nonatomic) IBOutlet UIButton *range;

@property (weak, nonatomic) IBOutlet UIImageView *eventImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *poster;
@property (weak, nonatomic) IBOutlet UILabel *place;

@property (nonatomic,copy) NSString* isMember;
@property (nonatomic,copy) NSString* DiscussionRoomId;
@property (nonatomic,copy) id <updateDatabaseDelegate>delegate;



- (IBAction)join:(id)sender;
- (IBAction)detail:(id)sender;
- (IBAction)addrange:(id)sender;


@end
