//
//  member.m
//  BRSliderController
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "member.h"

@implementation member



-(member *)initWithDic:(NSDictionary*)dic{
    if(self=[super init]){
        self.UserId=dic[@"UserId"];
        self.ScreenName=dic[@"ScreenName"];
        self.Identity=dic[@"Identity"];
        self.Portrait=dic[@"Portrait"];
        self.UserId=dic[@"UserId"];
        self.NickName=dic[@"NickName"];
        self.type=dic[@"type"];
    }
    return self;
}

#pragma mark 带参数的静态对象初始化方法
+(member *)initWithDic:(NSDictionary*)dic{
    member*person=[[member alloc]initWithDic:dic];
    return person;
}

@end
