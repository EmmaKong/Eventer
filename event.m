//
//  event.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "event.h"

@implementation event
- (event *)initWithDictionary:(NSDictionary *)dic{
    
    if (self  = [super init]) {
        self.zactivityId=dic[@"zactivityId"];
        self.zcontent=dic[@"zcontent"];
        self.zisStop=dic[@"zisStop"];
        self.zisVisit=dic[@"zisVisit"];
        self.zmoperator=dic[@"zmoperator"];
        self.zoperateTime=dic[@"zoperateTime"];
        self.zoperation=dic[@"zoperation"];
        self.zpubtime=dic[@"zpubtime"];
        self.zsource=dic[@"zsource"];
        self.ztitle=dic[@"ztitle"];
        self.zurl=dic[@"zurl"];
        self.ztype=dic[@"ztype"];
        self.zsourceicon=dic[@"zsourceicon"];
        self.evaluate=dic[@"evaluate"];
        
    }
    return self;
    
}


+ (event *)eventWithDictionary:(NSDictionary *)dic;{
    
    event * _event =[[event alloc]initWithDictionary:dic];
    
    return _event;
    
}
@end

