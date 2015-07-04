//
//  MoreInfoMenu.h
//  BRSliderController
//
//  Created by admin on 15/6/16.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol moreInfoViewDelegate <NSObject>

-(void)didSelectedCellAtIndex:(NSUInteger)index withTitle:(NSString *)title;

@end
@interface MoreInfoMenu : UITableView<UITableViewDataSource,UITableViewDelegate>

-(void)setCellTitles:(NSArray *)titles;
@end
