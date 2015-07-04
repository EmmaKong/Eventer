//
//  comment.h
//  BRSliderController
//
//  Created by admin on 15/5/19.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface comment : NSObject
@property (nonatomic,strong) NSNumber* CommentId;
@property (nonatomic,strong) NSNumber* DiscussionroomId;
@property (nonatomic,strong) NSString* Floor;
@property (nonatomic,strong) NSString* Talker;
@property (nonatomic,strong) NSString* repliedUser;
@property (nonatomic,strong) NSString* Type;
@property (nonatomic,strong) NSString* Comment;
@property (nonatomic,strong) NSString* Commenttype;
@property (nonatomic,strong) NSString* Imgpath;
@property (nonatomic,strong) NSString* addTime;
@property (nonatomic,strong) NSString* status;

- (comment * )initWithDictionary:(NSDictionary *)dic;

#pragma mark 初始化微博对象（静态方法）
+ (comment *)commentWithDictionary:(NSDictionary *)dic;
@end
