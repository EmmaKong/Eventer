//
//  courseWeekChooseView.m
//  Eventer
//
//  Created by admin on 15/6/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "courseWeekChooseView.h"
#import "courseChooseCell.h"
#define kDuration 0.3
@implementation courseWeekChooseView

- (IBAction)didSelectCourseWeek:(id)sender {
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }

}

- (id)initWithTitle:(NSString *)title delegate:(id <UIActionSheetDelegate>)delegate
{
    self.delegate = delegate;
    self.titleLabel.text = title;
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    
    return self;
        
}
- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height-64, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}


#pragma mark collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 5;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    courseChooseCell *cell = (courseChooseCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"courseChooseCell" forIndexPath:indexPath];
    cell.indexpath=indexPath;
    return cell;
}


@end
