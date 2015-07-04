//
//  roomDetail.h
//  BRSliderController
//
//  Created by admin on 15/4/29.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventIntroCell.h"
@interface roomDetail : UITableViewController<updateDatabaseDelegate>
@property(nonatomic,strong)NSString*roomId;
@property(nonatomic,strong)NSString*roomName;
@property(nonatomic,strong)NSString*roomIntro;
@property(nonatomic,strong)NSString*roomIcon;
@end
