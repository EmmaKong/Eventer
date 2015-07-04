//
//  Activity.h
//  Calendar
//
//  Created by emma on 15/5/12.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

@property (nonatomic, copy) NSString     *ScheduleID;
@property (nonatomic, copy) NSString     *EventName;
@property (nonatomic, copy) NSString     *Status;
@property (nonatomic, copy) NSString     *Date;
@property (nonatomic, copy) NSString     *StartTime;
@property (nonatomic, copy) NSString     *EndTime;
@property (nonatomic, copy) NSString     *Place;
@property (nonatomic, copy) NSString     *ShouldRemind;
@property (nonatomic, copy) NSString     *RemindTime;
@property (nonatomic, copy) NSString     *Description;
@property (nonatomic, copy) NSString     *Duration;
@property (nonatomic, copy) NSString     *Companion;
@property (nonatomic, copy) NSString     *frequency;
@property (nonatomic, copy) NSString     *sponsor;


@property (nonatomic, assign) BOOL      isChecked;

- (id)initWithPropertiesDictionary:(NSDictionary *)dic;

@end
