//
//  ActivityTimePickerView.h
//  Calendar
//
//  Created by emma on 15/6/9.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Activity.h"

@interface ActivityTimePickerView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource > {
@private

    NSArray  *begins;
    NSArray   *ends;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *timePicker;
//@property (strong, nonatomic) Activity *activity;
@property (strong,nonatomic) NSString*startTime;
@property (strong,nonatomic) NSString*endTime;

- (id)initWithTitle:(NSString *)title delegate:(id <UIActionSheetDelegate>)delegate;

- (void)showInView:(UIView *)view;


@end
