//
//  imagedisplayCellTableViewCell.h
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol showImgDetailDelagate<NSObject>
-(void)showDetail:(UITableViewController*)vc;

@end

@interface imagedisplayCell : UITableViewCell

@property (nonatomic,assign) id<showImgDetailDelagate> delegate;
//@property (nonatomic,assign)CGFloat height;
@end
