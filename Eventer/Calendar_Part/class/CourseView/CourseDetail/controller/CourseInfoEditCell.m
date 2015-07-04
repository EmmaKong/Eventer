//
//  CourseInfoEditCell.m
//  Eventer
//
//  Created by admin on 15/6/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "CourseInfoEditCell.h"

@implementation CourseInfoEditCell
{
    WeekCourse *_weekCourse;
}


- (instancetype)init:(WeekCourse *)weekCourse{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _weekCourse = weekCourse;
    
    [self generateInfoCell];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.courseTextfield];
    
    return self;
}

- (void)generateInfoCell{
    
    CGFloat padding = 20;
    
    UILabel *coursetitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding/2, 50, 20)];
    coursetitleLabel.text = @"课程";
    coursetitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:coursetitleLabel];
    self.courseTextfield=[[UITextField alloc]initWithFrame:CGRectMake(100, padding/2, 150, 20)];
    self.courseTextfield.text=_weekCourse.CourseName;
    self.courseTextfield.font=[UIFont systemFontOfSize:15];
    self.courseTextfield.layer.borderColor=(__bridge CGColorRef)([UIColor clearColor]);
    [self.contentView addSubview:self.courseTextfield];
    
    
    UILabel *teachertitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(self.courseTextfield.frame) + 6, 50, 20)];
    teachertitleLabel.text = @"教师";
    teachertitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:teachertitleLabel];
    
    UITextField*teacherTextfield=[[UITextField alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(self.courseTextfield.frame) + 6, 150, 20)];
    teacherTextfield.text=_weekCourse.Teacher;
    teacherTextfield.font=[UIFont systemFontOfSize:15];
    teacherTextfield.layer.borderColor=(__bridge CGColorRef)([UIColor clearColor]);
    [self.contentView addSubview:teacherTextfield];
    
    
    UILabel *classtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(teacherTextfield.frame) + 6, 50, 20)];
    classtitleLabel.text = @"教室";
    classtitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:classtitleLabel];
    
    UITextField *classTextfield = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(teacherTextfield.frame) + 6, 150, 20)];
    classTextfield.text = _weekCourse.Place;
    classTextfield.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:classTextfield];
    
    UILabel *lessonsNumtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(classTextfield.frame) + 6, 50, 20)];
    lessonsNumtitleLabel.text = @"节数";
    lessonsNumtitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:lessonsNumtitleLabel];
    
    UILabel *lessonsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(classTextfield.frame) + 6, 150, 20)];
    
    NSString *weekday;
    if ([@"1" isEqualToString:_weekCourse.weekDay]) {
        weekday = @"周一";
    }else if ([@"2" isEqualToString:_weekCourse.weekDay]){
        weekday = @"周二";
    }else if ([@"3" isEqualToString:_weekCourse.weekDay]){
        weekday = @"周三";
    }else if ([@"4" isEqualToString:_weekCourse.weekDay]){
        weekday = @"周四";
    }else if ([@"5" isEqualToString:_weekCourse.weekDay]){
        weekday = @"周五";
    }else if ([@"6" isEqualToString:_weekCourse.weekDay]){
        weekday = @"周六";
    }else if([@"7" isEqualToString:_weekCourse.weekDay]){
        weekday = @"周日";
    }else {
        weekday = _weekCourse.weekDay;
    }
    
    lessonsNumLabel.text = [NSString stringWithFormat:@"%@  %@－%d节",weekday,_weekCourse.lesson,_weekCourse.lesson.intValue +_weekCourse.lessonNum.intValue-1];
    lessonsNumLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:lessonsNumLabel];
    
    UILabel *seWeektitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(lessonsNumLabel.frame) + 6, 50, 20)];
    seWeektitleLabel.text = @"周数";
    seWeektitleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:seWeektitleLabel];
    
    UILabel *seWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(lessonsNumLabel.frame) + 6, 150, 20)];
    NSString *seWeek =[NSString stringWithFormat:@"%@-%@无课周%@",_weekCourse.StartWeek,_weekCourse.EndWeek,_weekCourse.NoClassWeek];
    
    seWeekLabel.text = seWeek;
    seWeekLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:seWeekLabel];
    
    self.height = CGRectGetMaxY(seWeekLabel.frame) + padding/2;
    
    
    
    
}

#pragma mark textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField  resignFirstResponder];
    return  YES;
}

#pragma mark notification
- (void)textFieldChanged:(id)sender
{
    NSLog(@"textfield did changed");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
