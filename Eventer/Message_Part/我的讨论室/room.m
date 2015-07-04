//
//  room.m
//  BRSliderController
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "room.h"

@implementation room
- (room *)initWithDictionary:(NSDictionary *)dic{
    
    if (self  = [super init]) {
        self.DiscussionRoomId=dic[@"DiscussionRoomId"];
        self.ActivityId=dic[@"ActivityId"];
        self.creatTime=dic[@"creatTime"];
        self.roomOwner=dic[@"roomOwner"];
        self.isShownname=dic[@"isShownname"];
        self.ModifyTime=dic[@"ModifyTime"];
        self.isStop=dic[@"isStop"];
        self.isMember=dic[@"isMember"];
        self.roomIntro=dic[@"roomIntro"];
    }
    return self;
    
}


+ (room *)roomWithDictionary:(NSDictionary *)dic;{
    
    room * _room =[[room alloc]initWithDictionary:dic];
    
    return _room;
    
}

@end
