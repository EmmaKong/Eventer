//
//  room.h
//  BRSliderController
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface room : NSObject

@property (nonatomic,strong) NSString*DiscussionRoomId;
@property (nonatomic,strong) NSString*ActivityId;
@property (nonatomic,strong) NSString*creatTime;
@property (nonatomic,strong) NSString*roomOwner;
@property (nonatomic,strong) NSString*isShownname;
@property (nonatomic,strong) NSString*ModifyTime;
@property (nonatomic,strong) NSString*isStop;
@property (nonatomic,strong) NSString*isMember;
@property (nonatomic,strong) NSString*roomIntro;

- (room * )initWithDictionary:(NSDictionary *)dic;

#pragma mark 初始化微博对象（静态方法）
+ (room *)roomWithDictionary:(NSDictionary *)dic;
@end
