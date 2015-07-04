//
//  eventBlock.h
//  WFCoretext
//
//  Created by admin on 15/6/8.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol eventClickDelegate <NSObject>

- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index;

@end

@interface eventBlock : UIView
@property(nonatomic,assign)id<eventClickDelegate>delegate;
//@property(nonatomic,strong)UIImage *image;
//@property(nonatomic,strong)UILabel *title;
//-(void)setEventBlockwithImg:(NSString*)imgpath content:(NSString*)content;

@end

