//
//  DiscussionRoomItemCell.h
//  BRSliderController
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTextData.h"
#import "WFTextView.h"
#import "YMButton.h"
#import "eventBlock.h"

@protocol DisscussRoomcellDelegate <NSObject>

- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger) cellStamp;
//- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;
- (void)showEventImagewithEventId:(NSInteger*)eventId;
- (void)showUserInformationbyUserId:(NSInteger*)userId;
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
@end

@interface DiscussionRoomItemCell : UITableViewCell<WFCoretextDelegate>
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray * ymTextArray;
@property (nonatomic,strong) NSMutableArray * ymFavourArray;
@property (nonatomic,strong) NSMutableArray * ymShuoshuoArray;
@property (nonatomic,strong) NSMutableArray * eventArray;
@property (nonatomic,assign) id<DisscussRoomcellDelegate> delegate;
@property (nonatomic,assign) NSInteger stamp;
@property (nonatomic,strong) YMButton *replyBtn;

@property (nonatomic,strong) UIImageView *favourImage;//点赞的图

/**
 *  用户头像imageview
 */
@property (nonatomic,strong) UIImageView *userHeaderImage;

/**
 *  分享时间
 */
@property (nonatomic,strong) UILabel *shareTime;

/**
 *  用户昵称label
 */
@property (nonatomic,strong) UILabel *userNameLbl;

/**
 *  用户分享的活动块block
 */
@property (nonatomic,strong)  eventBlock*eventblock;




- (void)setYMViewWith:(YMTextData *)ymData;

@end
