//
//  chatRecord.h
//  BRSliderController
//
//  Created by admin on 15/5/27.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chatRecord : NSObject
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* participantId;
@property(nonatomic,strong) NSString* avatar;
@property(nonatomic,strong) NSString* lastMsg;
@property(nonatomic,strong) NSString* time;

- (chatRecord *)initWithDictionary:(NSDictionary *)dic;
+(chatRecord*)chatRecordWithDic:(NSDictionary*)dic;
@end
