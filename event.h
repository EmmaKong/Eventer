//
//  event.h
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface event : NSObject
#pragma mark - 属性
@property (nonatomic,strong) NSNumber* zactivityId;
@property (nonatomic,strong) NSString* zpubtime;
@property (nonatomic,strong) NSString* ztype;
@property (nonatomic,strong) NSString* ztitle;
@property (nonatomic,strong) NSString* zsource;
@property (nonatomic,strong) NSString* zsourceicon;
@property (nonatomic,strong) NSString* zisStop;
@property (nonatomic,strong) NSString* zmoperator;
@property (nonatomic,strong) NSString* zoperation;
@property (nonatomic,strong) NSString* zoperateTime;
@property (nonatomic,strong) NSString* zcontent;
@property (nonatomic,strong) NSString* zurl;
@property (nonatomic,strong) NSString* zisVisit;
@property (nonatomic,strong) NSString* evaluate;


#pragma mark - 动态方法
#pragma mark - 方法
#pragma mark 根据字典初始化微博对象
- (event * )initWithDictionary:(NSDictionary *)dic;

#pragma mark 初始化微博对象（静态方法）
+ (event *)eventWithDictionary:(NSDictionary *)dic;


@end

