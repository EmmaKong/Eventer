//
//  comment.m
//  BRSliderController
//
//  Created by admin on 15/5/19.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "comment.h"

@implementation comment
- (comment *)initWithDictionary:(NSDictionary *)dic{
    
    if (self  = [super init]) {
        self.CommentId = dic[@"CommentId"];
        self.DiscussionroomId=dic[@"DiscussionroomId"];
        self.Floor=dic[@"Floor"];
        self.Talker=dic[@"Talker"];
        self.repliedUser=dic[@"repliedUser"];
        self.Type=dic[@"Type"];
        self.Comment = dic[@"Comment"];
        self.Commenttype = dic[@"Commenttype"];
        self.Imgpath=dic[@"Imgpath"];
        self.addTime = dic[@"addTime"];
        self.status=dic[@"status"];
    }
    return self;
    
}


+(comment *)commentWithDictionary:(NSDictionary *)dic{
    
    comment * commentinfo = [[comment alloc]initWithDictionary:dic];
    
    return commentinfo;
    
}
@end
