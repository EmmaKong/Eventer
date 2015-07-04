//
//  member.h
//  BRSliderController
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface member : NSObject
@property (nonatomic,copy) NSString *UserId;

@property (nonatomic,copy) NSString *ScreenName;

@property (nonatomic,copy) NSString *Identity;

@property (nonatomic,copy) NSString *Portrait;

@property (nonatomic,copy) NSString *NickName;

@property (nonatomic,copy) NSString *type;

#pragma mark 带参数的构造函数
-(member *)initWithDic:(NSDictionary*)dic;




#pragma mark 带参数的静态对象初始化方法
+(member *)initWithDic:(NSDictionary*)dic;
@end
