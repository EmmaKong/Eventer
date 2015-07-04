//
//  CourseInfoEditCell.h
//  Eventer
//
//  Created by admin on 15/6/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "CourseDetailCell.h"
#import "WeekCourse.h"
@interface CourseInfoEditCell : CourseDetailCell
- (instancetype)init:(WeekCourse *)weekCourse;
@property (nonatomic,strong)UITextField*courseTextfield;
@end
