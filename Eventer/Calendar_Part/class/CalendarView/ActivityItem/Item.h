//
//  Item.h
//  Calendar
//
//  Created by emma on 15/6/11.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, copy) NSString     *title;
@property (nonatomic, copy) NSString     *date;
@property (nonatomic, copy) NSString     *begintime;
@property (nonatomic, copy) NSString     *endtime;

@property (nonatomic, copy) NSString     *address;
@property (nonatomic, copy) NSString     *itemID;
@property (nonatomic, assign) BOOL      isCourse;   // 是课程还是一般活动


@end
