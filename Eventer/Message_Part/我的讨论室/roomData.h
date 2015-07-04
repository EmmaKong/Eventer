//
//  roomData.h
//  BRSliderController
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "room.h"
@interface roomData : NSObject
@property(nonatomic,strong)NSString* roomIcon;
@property(nonatomic,strong)NSString* roomName;
@property(nonatomic,strong)NSString* roomIntro;
@property(nonatomic,strong)NSString* lastModifyTime;
@property(nonatomic,strong)NSString* roomId;



- (roomData * )initWithRoom:(room *)room;

#pragma mark 初始化微博对象（静态方法）
+ (roomData *)roomDataWithRoom:(room *)room;
@end
