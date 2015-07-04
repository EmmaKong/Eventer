//
//  databaseCreater.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "databaseCreator.h"
#import "databaseService.h"

@implementation databaseCreator
+(void)initDatabase{
    NSString *key=@"IsCreatedDb";
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    [defaults setObject:@0 forKey:key];
    NSLog(@"%@",[defaults valueForKey:key]);
    if ([[defaults valueForKey:key] intValue]!=1) {
        [self createEventTable];
        [self createMessageTable];
        [self creatTempTable];
        [self creatShareTable];
        [self createUserTable];
        [self creatShareCommentTable];
        [self creatEventRoomComment];
        [self createRoomsTable];
//        [self creatContactTable];
        [self createCourseTable];
        [self creatScheduleTable];
        [self creatMobileContactTable];
        [defaults setObject:@1 forKey:key];
    }
}

+(void)createCourseTable{
    NSDictionary*condition=[NSDictionary dictionaryWithObjectsAndKeys:@"int",@"CourseID",@"nvarchar",@"CourseName",@"int",@"Status",@"int",@"lesson",@"int",@"lessonNum",@"nvarchar",@"Place",@"nvarchr",@"Teacher",@"int",@"StartWeek",@"int",@"EndWeek",@"nvarchar",@"NoClassWeek",@"varchar",@"Companion",@"varchar",@"TeacherTel",@"varchar",@"TeacherEmail",@"varchar",@"color",@"varchar",@"weekDay", nil];
//    NSArray*tablekeys=@[@"CourseID",@"CourseName",@"Status",@"ClassHour",@"Place",@"Teacher",@"StartWeek",@"EndWeek",@"NoClassWeek",@"Companion",@"TeacherTel",@"TeacherEmail",@"color",@"weekDay"];
    [[databaseService shareddatabaseService]createTableWithName:@"dbCourse" withCondition:condition];
    NSArray*array=[self GetjsonDataWithFileName:@"Course"];
    
    for (NSDictionary*obj in array) {
        [[databaseService shareddatabaseService]insert:obj toTable:@"dbCourse"];
    }
    
}

+(void)creatScheduleTable{
    NSDictionary*condition=[NSDictionary dictionaryWithObjectsAndKeys:@"nvarchar",@"ScheduleID",@"nvarchar",@"EventName",@"int",@"Status",@"varchar",@"StartTime",@"varchar",@"EndTime",@"varchar",@"Date",@"nvarchar",@"Place",@"int",@"ShouldRemind",@"varchar",@"RemindTime",@"nvarchar",@"Description",@"int",@"Duration",@"varchar",@"Companion",@"int",@"frequency",@"varchar",@"sponsor", nil];
    [[databaseService shareddatabaseService]createTableWithName:@"dbSchedule" withCondition:condition];
    NSArray*array=[self GetjsonDataWithFileName:@"activities"];
    
    for (NSDictionary*obj in array) {
        [[databaseService shareddatabaseService]insert:obj toTable:@"dbSchedule"];
    }
}




+(void)createRoomsTable{
    NSArray*tablekeys=@[@"DiscussionRoomId",@"ActivityId",@"creatTime",@"roomOwner",@"isShownname",@"ModifyTime",@"isStop",@"isMember",@"roomIntro"];
    [[databaseService shareddatabaseService]createTableWithName:@"dbEventRoomList" withKeys:(NSMutableArray*)tablekeys];
    NSArray*array=[self GetjsonDataWithFileName:@"rooms"];
    
    for (NSDictionary*obj in array) {
        [[databaseService shareddatabaseService]insert:obj toTable:@"dbEventRoomList"];
    }
    
}




+(void)createUserTable{
    NSArray*tablekeys=@[@"UserId",@"ScreenName",@"NickName",@"AvatarIcon",@"type",@"Identity"];
    [[databaseService shareddatabaseService]createTableWithName:@"dbUser" withKeys:(NSMutableArray*)tablekeys];
    NSArray*array=[self GetjsonDataWithFileName:@"User"];
    
    for (NSDictionary*obj in array) {
        [[databaseService shareddatabaseService]insert:obj toTable:@"dbUser"];
    }
    
}

+(void)creatEventRoomComment{
    
    NSArray*tablekeys=@[@"CommentId",@"DiscussionRoomId",@"Floor",@"Talker",@"replied",@"Type",@"Comment",@"CommentType",@"Imgpath",@"addTime",@"status"];
    [[databaseService shareddatabaseService]createTableWithName:@"dbEventRoomComment" withKeys:(NSMutableArray*)tablekeys];
    NSArray*array=[self GetjsonDataWithFileName:@"TalkRecord"];
    
    for (NSDictionary*obj in array) {
        [[databaseService shareddatabaseService]insert:obj toTable:@"dbEventRoomComment"];
    }
    
    
}


+(void)createEventTable{
    NSArray*tablekeys=@[@"zactivityId",@"zpubtime",@"ztype",@"ztitle",@"zsource",@"zsourceicon",@"zisStop",@"zmoperator",@"zoperation",@"zoperateTime",@"zcontent",@"zurl",@"zisVisit",@"evaluate"];
    [[databaseService shareddatabaseService]createTableWithName:@"dbEvent" withKeys:(NSMutableArray*)tablekeys];
    NSArray*array=[self GetjsonDataWithFileName:@"activity"];
    for (NSDictionary*obj in array) {
        [[databaseService shareddatabaseService]insert:obj toTable:@"dbEvent"];
    }
    
}


+(void)createMessageTable{
    NSArray*tablekeys=@[@"messageGroupId",@"posterId",@"catcherId",@"msgId",@"text",@"date",@"messageType",@"mediaType",@"img"];
    [[databaseService shareddatabaseService]createTableWithName:@"dbMessage" withKeys:(NSMutableArray*)tablekeys];
}

+(void)creatTempTable
{
    NSMutableArray*tableKeys=(NSMutableArray*)@[@"name",@"participantId",@"avatar",@"lastMsg",@"time"];
    [[databaseService shareddatabaseService]createTableWithName:@"chatRecord" withKeys:tableKeys];
}


+(void)creatShareTable{
    NSMutableArray*tableKeys=(NSMutableArray*)@[@"shareId",@"Talker",@"ActivityId",@"shareContent",@"shareTime"];
    [[databaseService shareddatabaseService]createTableWithName:@"dbShare" withKeys:tableKeys];
    NSArray*array=[self GetjsonDataWithFileName:@"shareinfo"];
    
    for (NSDictionary*obj in array) {
        [[databaseService shareddatabaseService]insert:obj toTable:@"dbShare"];
    }
}

+(void)creatShareCommentTable{
    NSMutableArray*tableKeys=(NSMutableArray*)@[@"shareId",@"replyId",@"reply",@"replied",@"replyContent",@"replyTime"];
    [[databaseService shareddatabaseService]createTableWithName:@"dbShareComment" withKeys:tableKeys];
    NSArray*array=[self GetjsonDataWithFileName:@"shareComment"];
    
    for (NSDictionary*obj in array) {
        [[databaseService shareddatabaseService]insert:obj toTable:@"dbShareComment"];
    }
    
    
}
+(void)creatContactTable{
    NSDictionary*condition=[NSDictionary dictionaryWithObjectsAndKeys:@"varchar",@"ContactcName",@"varchar",@"Nickname", @"varchar",@"Place",@"varchar",@"introduce",@"varchar",@"avatar",@"varchar",@"ContactId",nil];
    [[databaseService shareddatabaseService]createTableWithName:@"dbContact" withCondition:condition];
    [self loadLocalData];
    NSDictionary*Contact=[NSDictionary dictionaryWithObjectsAndKeys:@"xiaoming",@"ClientName", @"2",@"Nickname",nil];
    [[databaseService shareddatabaseService]insert:Contact toTable:@"dbContact"];
    //    NSArray*array=[self GetjsonDataWithFileName:@"shareComment"];
    //
    //    for (NSDictionary*obj in array) {
    //        [[databaseService shareddatabaseService]insert:obj toTable:@"dbShareComment"];
    //    }
    
}


+(void)creatMobileContactTable{
    NSDictionary*condition=[NSDictionary dictionaryWithObjectsAndKeys:@"varchar",@"contactName",@"varchar",@"image", @"varchar",@"sectionIndex",@"varChar",@"phoneNum",@"varchar",@"contactID",nil];
    [[databaseService shareddatabaseService]createTableWithName:@"dbMobileContact" withCondition:condition];
   }




+(NSArray*)GetjsonDataWithFileName:(NSString*)filename{
    
    NSString*path=[[NSBundle mainBundle]pathForResource:filename ofType:@"json"];
    NSData*jsonData=[[NSData alloc]initWithContentsOfFile:path];
    NSError*error;
    id jsonobj=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(!jsonobj||error)
    {
        NSLog(@"解析失败");
    }
    NSArray*array=[jsonobj objectForKey:@"Record"];
    return array;
}

+(NSArray*)loadLocalData
{
    NSArray*dataArray=[[NSArray alloc]init];
    NSString *contactsPath = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:contactsPath];
    //解析
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    dataArray = [dict objectForKey:@"data"];
    return [dataArray copy];
    
    
}

@end