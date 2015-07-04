//
//  WFMessageBody.h
//  WFCoretext
//
//  Created by 阿虎 on 15/4/29.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFMessageBody : NSObject
/**
 *  分享活动的ID
 */
@property (nonatomic,copy) NSString *shareID;
/**
 *  用户头像url 此处直接用图片名代替
 */
@property (nonatomic,copy) NSString *posterImgstr;

/**
 *  用户名
 */
@property (nonatomic,copy) NSString *posterName;



/**
 *  用户说说内容
 */
@property (nonatomic,copy) NSString *posterContent;

/**
 *  用户分享时间
 */
@property (nonatomic,copy) NSString *shareTime;

/**
 *  用户分享的活动名称
 */
@property (nonatomic,copy) NSString *posterEventName;
/**
 *  用户分享的活动图片
 */
@property (nonatomic,copy) NSString *posterEventImg;
/**
 *  用户分享的活动简介
 */
@property (nonatomic,copy) NSString *posterEventIntro;
/**
 *  用户分享的活动链接
 */
@property (nonatomic,copy) NSString *posterEventURL;

/**
 *  用户收到的赞 (该数组存点赞的人的昵称)
 */
@property (nonatomic,strong) NSMutableArray *posterFavour;

/**
 *  用户说说的评论数组
 */
@property (nonatomic,strong) NSMutableArray *posterReplies;

/**
 *  admin是否赞过
 */
@property (nonatomic,assign) BOOL isFavour;

@end
