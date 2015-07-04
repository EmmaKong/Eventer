//
//  courseWeekChooseView.h
//  Eventer
//
//  Created by admin on 15/6/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface courseWeekChooseView : UIActionSheet



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)didSelectCourseWeek:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

- (id)initWithTitle:(NSString *)title delegate:(id <UIActionSheetDelegate>)delegate;
- (void)showInView:(UIView *)view;
@end
