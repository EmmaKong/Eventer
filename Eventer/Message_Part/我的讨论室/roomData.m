//
//  roomData.m
//  BRSliderController
//
//  Created by admin on 15/6/11.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "roomData.h"
#import "room.h"
#import "databaseService.h"
@implementation roomData
- (roomData *)initWithRoom:(room *)roomItem{
    
    if (self  = [super init]) {
        NSDictionary*condition=[NSDictionary dictionaryWithObject:roomItem.ActivityId forKey:@"zactivityId"];
        NSString*infoWanted=[NSString stringWithFormat:@"ztitle,zsourceicon"];
        NSDictionary*eventInfoSeleted=[[[databaseService shareddatabaseService]get :infoWanted FromTable:@"dbEvent" WithCondition:condition] allValues][0];
        self.roomName=[eventInfoSeleted objectForKey:@"ztitle"];
        self.roomIcon=[eventInfoSeleted objectForKey:@"zsourceicon"];
        self.roomIntro=roomItem.roomIntro;
        self.lastModifyTime=roomItem.ModifyTime;
        self.roomId=roomItem.DiscussionRoomId;
    }
    return self;
    
}


+ (roomData *)roomDataWithRoom:(room *)room{
    
    roomData * _roomData =[[roomData alloc]initWithRoom:room];
    
    return _roomData;
    
}

@end
