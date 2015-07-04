//
//  chatRecord.m
//  BRSliderController
//
//  Created by admin on 15/5/27.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "chatRecord.h"

@implementation chatRecord

- (chatRecord *)initWithDictionary:(NSDictionary *)dic{
    
    if (self  = [super init]) {
        self.name=dic[@"name"];
        self.participantId=dic[@"participantId"];
        self.avatar=dic[@"avatar"];
        self.lastMsg=dic[@"lastMsg"];
        self.time=dic[@"time"];
    }
    return self;
    
}
+(chatRecord*)chatRecordWithDic:(NSDictionary*)dic
{
    chatRecord *chatitem=[[chatRecord alloc]initWithDictionary:dic];
    return chatitem;
}
@end
