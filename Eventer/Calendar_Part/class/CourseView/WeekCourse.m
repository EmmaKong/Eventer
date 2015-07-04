//
//  WeekCourse.m
//  Calendar
//
//  Created by emma on 15/5/7.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "WeekCourse.h"

@implementation WeekCourse
- (id)initWithPropertiesDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic != nil) {

            self.CourseName=[dic objectForKey:@"CourseName"];
            self.CourseID=[dic objectForKey:@"CourseID"];
            self.Status=[dic objectForKey:@"Status"];
            self.lesson=[dic objectForKey:@"lesson"];
            self.lessonNum=[dic objectForKey:@"lessonNum"];
            self.Place=[dic objectForKey:@"Place"];
            self.Teacher=[dic objectForKey:@"Teacher"];
            self.StartWeek=[dic objectForKey:@"StartWeek"];
            self.EndWeek=[dic objectForKey:@"EndWeek"];
            self.NoClassWeek=[dic objectForKey:@"NoClassWeek"];
            self.Companion=[dic objectForKey:@"Companion"];
            self.TeacherTel=[dic objectForKey:@"TeacherTel"];
            self.TeacherEmail=[dic objectForKey:@"TeacherEmail"];
            self.color=[dic objectForKey:@"color"];
            self.weekDay=[dic objectForKey:@"weekDay"];
            
        }
    }
    return self;
}




@end
