//
//  Activity.m
//  Calendar
//
//  Created by emma on 15/5/12.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "Activity.h"

@implementation Activity


- (id)initWithPropertiesDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic != nil) {
            self.ScheduleID = [dic objectForKey:@"ScheduleID"];
            self.EventName = [dic objectForKey:@"EventName"];
            self.Status = [dic objectForKey:@"Status"];
            self.Date = [dic objectForKey:@"Date"];
            self.StartTime = [dic objectForKey:@"StartTime"];
            self.EndTime = [dic objectForKey:@"EndTime"];
            self.Place = [dic objectForKey:@"Place"];
            self.ShouldRemind = [dic objectForKey:@"ShouldRemind"];
            self.RemindTime = [dic objectForKey:@"RemindTime"];
            self.Description = [dic objectForKey:@"Description"];
            self.Duration = [dic objectForKey:@"Duration"];
            self.Companion = [dic objectForKey:@"Companion"];
            self.frequency = [dic objectForKey:@"frequency"];
            self.sponsor = [dic objectForKey:@"sponsor"];
    
        }
    }
    
    return self;
}




@end
