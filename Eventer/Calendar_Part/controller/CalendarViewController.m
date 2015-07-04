//
//  CalendarViewController.m
//  Calendar
//
//  Created by emma on 15/5/14.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CalendarViewController.h"
#import "NSDate+Extension.h"
#import "SSLunarDate.h"
#import "databaseService.h"

#define kPink [UIColor colorWithRed:198/255.0 green:51/255.0 blue:42/255.0 alpha:1.0]
#define kBlue [UIColor colorWithRed:31/255.0 green:119/255.0 blue:219/255.0 alpha:1.0]
#define kBlueText [UIColor colorWithRed:14/255.0 green:69/255.0 blue:221/255.0 alpha:1.0]

@interface CalendarViewController ()
@property (strong, nonatomic) NSCalendar *currentCalendar;
@property (strong, nonatomic) SSLunarDate *lunarDate;

@end

@implementation CalendarViewController
-(instancetype)init{
    self=[super init];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tabBarController.tabBar.translucent=NO;
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.title = @"日历";

    

    CGRect frame = CGRectMake(0, 100, self.view.frame.size.width, 250);
    
    self.calendar = [[Calendar alloc] initWithFrame:(CGRect)frame];
    self.calendar.delegate = self;
    self.calendar. dataSource = self;
    [self.view addSubview:self.calendar];
    
    _currentCalendar = [NSCalendar currentCalendar];
    _flow = _calendar.flow;
    _firstWeekday = _calendar.firstWeekday;
    _calendar.firstWeekday = 2;  // 周一为第一天
    _currentDate = [NSDate date];
    
    
    self.itemtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 102+self.calendar.frame.size.height, self.view.frame.size.width, 15)];
    self.itemtitleLabel.font = [UIFont systemFontOfSize:15];
    self.itemtitleLabel.textAlignment = NSTextAlignmentCenter;
    //self.itemtitleLabel.textColor = [UIColor redColor];
    self.itemtitleLabel.text = [NSString stringWithFormat:@"%@",[_currentDate _stringWithFormat:@"yyyy""年""MM""月""dd""日"]];
    [self.view addSubview:self.itemtitleLabel];
    
    // activityitem 视图
    _activityItemVC = [[ActivityItemViewController alloc] init];
    _activityItemVC.view.frame =  CGRectMake(0, 368,ScreenWidth,ScreenHeight-368);
    [self addChildViewController:_activityItemVC];
    [self.view addSubview:_activityItemVC.view];


    // navigationitem 的title 视图， 设置长度为150
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];    
    titleView.backgroundColor = [UIColor clearColor];
    // 今天 按钮
    UIButton *todayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //todayBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    todayBtn.frame = (CGRect){0, 0, 40, 30};
    todayBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    todayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [todayBtn setTitle:@"今天" forState:UIControlStateNormal];
    
    [todayBtn addTarget:self action:@selector(backToCurrentMonth:) forControlEvents:UIControlEventTouchUpInside];
    //[todayBtn setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
    [titleView addSubview:todayBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((150-80)/2, 0, 80, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"月历视图"];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    //titleLabel.backgroundColor = [UIColor redColor];
    [titleView addSubview:titleLabel];
    
    // titleview，必须设置成navigationitem
    self.navigationItem.titleView = titleView;
   
}



#pragma mark - CalendarDataSource

- (NSString *)calendar:(Calendar *)calendarView subtitleForDate:(NSDate *)date
{
//    if (!_lunar) {
//        return nil;
//    }
    // 农历 显示
    _lunarDate = [[SSLunarDate alloc] initWithDate:date calendar:_currentCalendar];
    return _lunarDate.dayString;
}

// 有事件
- (BOOL)calendar:(Calendar *)calendarView hasEventForDate:(NSDate *)date
{
    NSString*dateString=[self stringFromDate:date];
    NSDictionary*dateCondition=[NSDictionary dictionaryWithObjectsAndKeys:dateString,@"Date", nil];
    NSDictionary*dateWithScheduleDic=[[databaseService shareddatabaseService]get:@"Date" FromTable:@"dbSchedule" WithCondition:dateCondition];

    if ([dateWithScheduleDic objectForKey:@"1"]!=nil) {
        NSLog(@"yes");
        return YES;

    }else{return NO;}

}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}



#pragma mark - Buttons callback

// 回到今天
- (void)backToCurrentMonth:(id)sender
{
    //_currentCalendar = [NSCalendar currentCalendar];

   //[_calendar setCurrentDate:[NSDate date]];

    _calendar.selectedDate = _currentDate;
     NSLog(@"今天");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.calendar reloadData]; // Must be call in viewDidAppear
}


#pragma mark - CalendarDelegate

- (void)calendar:(Calendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"did select date %@",[date _stringWithFormat:@"yyyy/MM/dd"]);
   
    NSString *currentDate = [NSString stringWithFormat:@"%@",[date _stringWithFormat:@"yyyy.MM.dd"]];
    self.itemtitleLabel.text=currentDate;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadCalendarData" object:date];
    
    
}

- (void)calendarCurrentMonthDidChange:(Calendar *)calendar
{
    NSLog(@"did change to month %@",[calendar.currentMonth _stringWithFormat:@"MMMM yyyy"]);
}


- (void)setSelectedDate:(NSDate *)selectedDate
{
    _calendar.selectedDate = selectedDate;
}

- (void)setFirstWeekday:(NSUInteger)firstWeekday
{
    if (_firstWeekday != firstWeekday) {
        _firstWeekday = firstWeekday;
        _calendar.firstWeekday = firstWeekday;
    }
}



@end
