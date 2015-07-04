//
//  AVSegmentController.h
//  Calendar
//
//  Created by emma on 15/6/4.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import <UIKit/UIKit.h>

// segmentcontrollerdelegate
@protocol AVSegmentControllerDelegate <NSObject>

-(NSString *)segmentTitle;

@optional
-(UIScrollView *)streachScrollView;

@end


@interface AVSegmentController : UIViewController

@property (nonatomic, assign) CGFloat segmentHeight;
//@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat segmentMiniTopInset;
@property (nonatomic, assign, readonly) CGFloat segmentToInset;

@property (nonatomic, weak, readonly) UIViewController<AVSegmentControllerDelegate> *currentDisplayController;


@property (nonatomic, assign) BOOL freezenHeaderWhenReachMaxHeaderHeight;

//用来保存segmentcontrol点击的数字，从而对添加事件作出判断，添加的事件到底是要做的还是收藏的
@property(nonatomic,retain) NSString *segmentIndex;

-(instancetype)initWithControllers:(UIViewController<AVSegmentControllerDelegate> *)controller,... NS_REQUIRES_NIL_TERMINATION;

-(void)setViewControllers:(NSArray *)viewControllers;



@end
