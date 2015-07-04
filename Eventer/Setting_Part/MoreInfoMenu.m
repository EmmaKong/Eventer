//
//  MoreInfoMenu.m
//  BRSliderController
//
//  Created by admin on 15/6/16.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "MoreInfoMenu.h"

@interface MoreInfoMenu()

@property(strong, nonatomic) NSArray *myCellTitles;

@end


@implementation MoreInfoMenu


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}



-(void)setCellTitles:(NSArray *)titles
{
    self.myCellTitles = [[NSArray alloc]initWithArray:titles];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myCellTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"moreInfoCell";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    cell.textLabel.text = self.myCellTitles[indexPath.row];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor blackColor]];
    [cell setAlpha:0.5];
    return cell;
}

@end
