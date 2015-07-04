//
//  courseChooseCell.m
//  Eventer
//
//  Created by admin on 15/6/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "courseChooseCell.h"

@implementation courseChooseCell

-(instancetype)init{
    self.button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    NSInteger row=self.indexpath.row;
    NSInteger section=self.indexpath.section;
    NSInteger num=row*5+section+1;
    [self.button setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    [self.contentView addSubview:self.button];
    return self;
}


@end
