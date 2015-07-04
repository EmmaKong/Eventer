//
//  MenuNavigationViewController.m
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "MenuNavigationViewController.h"
#import "CalendarViewController.h"
#import "CVViewController.h"
#import "ActivityViewController.h"
#import "ActivitySegmentViewController.h"

@interface MenuNavigationViewController () <CalendarMenuDelegate>

@property (strong, readwrite, nonatomic) CalendarMenu *menu;


@end

@implementation MenuNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.navigationBar.tintColor = [UIColor colorWithRed:98/255.0 green:158/255.0 blue:160/255.0 alpha:1];
    
    __typeof (self) __weak weakSelf = self;  // 弱变量
    
    CalendarMenuItem *CalendarItem = [[CalendarMenuItem alloc] initWithTitle:@"月历视图"
                                                                      action:^(CalendarMenuItem *item) {
                                                                          NSLog(@"Item: %@", item);
                                                                          CalendarViewController *controller=[[CalendarViewController alloc] init];
                                                                          //                                                                CalendarViewController *controller = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
                                                                          [weakSelf setViewControllers:@[controller] animated:NO];
                                                                      }];
//    CalendarMenuItem *DayItem = [[CalendarMenuItem alloc] initWithTitle:@"日程视图"
//                                                            action:^(CalendarMenuItem *item) {
//                                                                NSLog(@"Item: %@", item);
//                                                                DVViewController *controller = [[DVViewController alloc] init];
//                                                                [weakSelf setViewControllers:@[controller] animated:NO];
//                                                                }];
    
    CalendarMenuItem *CourseItem = [[CalendarMenuItem alloc] initWithTitle:@"课程视图"
                                                                                                                                action:^(CalendarMenuItem *item) {
                                                                                                                                    NSLog(@"Item: %@", item);
                                                                                                                                    CVViewController *controller = [[CVViewController alloc] init];
                                                                                                                                    [weakSelf setViewControllers:@[controller] animated:NO];
                                                                                                                                
                                                                 }];
    
    CalendarMenuItem *ActivityItem = [[CalendarMenuItem alloc] initWithTitle:@"事项列表"
                                                             action:^(CalendarMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                             ActivityViewController *controller = [[ActivityViewController alloc] init];
                                                         //   ActivitySegmentViewController *controller = [[ActivitySegmentViewController alloc] init];
                                                             [weakSelf setViewControllers:@[controller] animated:NO];
                                                                      }];
    

    
    CalendarItem.tag = 0;
//    DayItem.tag = 1;
    CourseItem.tag = 2;
    ActivityItem.tag = 3;
   
    self.menu = [[CalendarMenu alloc] initWithItems:@[CalendarItem,CourseItem, ActivityItem]];
    
     
    if (!CalendarUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor lightGrayColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    
    self.menu.separatorOffset = CGSizeMake(5.0, 0.0);   //分割线 offset
    self.menu.waitUntilAnimationIsComplete = YES;
    self.menu.delegate = self;
    
    
    [self.menu setClosePreparationBlock:^{
        NSLog(@"Menu will close");
    }];
    
    [self.menu setCloseCompletionHandler:^{
        NSLog(@"Menu did close");
    }];
    
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self];
}

#pragma mark - REMenu Delegate Methods

-(void)willOpenMenu:(CalendarMenu *)menu
{
    NSLog(@"Delegate method: %@", NSStringFromSelector(_cmd));
}

-(void)didOpenMenu:(CalendarMenu *)menu
{
    NSLog(@"Delegate method: %@", NSStringFromSelector(_cmd));
}

-(void)willCloseMenu:(CalendarMenu *)menu
{
    NSLog(@"Delegate method: %@", NSStringFromSelector(_cmd));
}

-(void)didCloseMenu:(CalendarMenu *)menu
{
    NSLog(@"Delegate method: %@", NSStringFromSelector(_cmd));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
