//
//  WFMessageBody.h
//  WFCoretext
//
//  Created by 阿虎 on 15/4/28.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFReplyBody : NSObject
/**
 *  评论id
 */
@property (nonatomic,copy) NSString *replyID;
/**
 *  评论time
 */
@property (nonatomic,copy) NSString *replyTime;
/**
 *  评论者
 */
@property (nonatomic,copy) NSString *replyUser;
/**
 *  评论者ID
 */
@property (nonatomic,copy) NSString *replyUserId;
/**
 *  回复该评论者的人的ID
 */
@property (nonatomic,copy) NSString *repliedUserId;
/**
 *  回复该评论者的人
 */
@property (nonatomic,copy) NSString *repliedUser;

/**
 *  回复内容
 */
@property (nonatomic,copy) NSString *replyInfo;


@end
