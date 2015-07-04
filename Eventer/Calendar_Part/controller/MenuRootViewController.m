//
//  MenuRootViewController.m
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "MenuRootViewController.h"
#import "MenuNavigationViewController.h"


@interface MenuRootViewController ()

@end

@implementation MenuRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 在根视图的rightBarButtonItem制作一个下拉列表，其他二级视图继承自它
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"视图切换" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
    
    // Demo label to show current controller class
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = NSStringFromClass(self.class);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    MenuNavigationViewController *navigationController = (MenuNavigationViewController *)self.navigationController;
    [navigationController.menu setNeedsLayout];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark Rotation

- (BOOL)shouldAutorotate // 无旋转
{
    //return YES;
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //return YES;
    return NO;
}

@end
