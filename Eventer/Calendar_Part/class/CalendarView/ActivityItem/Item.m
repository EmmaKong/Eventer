//
//  Item.m
//  Calendar
//
//  Created by emma on 15/6/11.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)initWithPropertiesDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic != nil) {
            self.title = [dic objectForKey:@"title"];
            self.date = [dic objectForKey:@"date"];
            self.address = [dic objectForKey:@"address"];
            self.begintime = [dic objectForKey:@"begintime"];
            self.endtime = [dic objectForKey:@"endtime"];
            self.itemID=[dic objectForKey:@"itemID"];
            
        }
    }
    
    return self;
}




@end
