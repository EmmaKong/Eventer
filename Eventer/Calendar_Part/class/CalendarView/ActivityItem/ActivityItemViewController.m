//
//  ActivityItemViewController.m
//  Calendar
//
//  Created by emma on 15/6/11.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ActivityItemViewController.h"
#import "ActivityDetailViewController.h"
#import "AddedCourseDetailVC.h"
#import "databaseService.h"
#import "DateUtils.h"

@interface ActivityItemViewController ()

@end

@implementation ActivityItemViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCalendarData:) name:@"reloadCalendarData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CalendarTableviewDeleteItem:) name:@"CalendarTableviewItemDeleteNotification" object:nil];
    
    itemtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    itemtableView.delegate = self;
    itemtableView.dataSource = self;

    itemtableView.backgroundColor = [UIColor clearColor];
  

    [self.view addSubview:itemtableView];
    [self loadCanlendarDataWithDate:[NSDate date]];
    

    
    itemtableView.contentSize = CGSizeMake(self.view.frame.size.width, 44*_todoArray.count);

}
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy.MM.dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (void)loadCanlendarDataWithDate:(NSDate *)date
{

    //加载当天要做的事项
    NSDictionary*fetchActivityCondition=[NSDictionary dictionaryWithObjectsAndKeys:[self stringFromDate:date],@"Date", nil];
    NSDictionary*activityTimeASC=[NSDictionary dictionaryWithObjectsAndKeys:@"ASC",@"StartTime", nil];
    NSDictionary*activityResults=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbSchedule" WithCondition:fetchActivityCondition orderby:activityTimeASC];
    _todoactivityArray = [[NSMutableArray alloc] init];  // NSMutableArray数组，添加object前，要先进行初始化
    for (int i=1; i<=[activityResults count]; i++) {
        NSDictionary*activitytemp=[activityResults objectForKey:[NSString stringWithFormat:@"%d",i]];
        [_todoactivityArray addObject:activitytemp];
    }

    NSLog(@"todocount%lu",(unsigned long)[_todoactivityArray count]);

    _todoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _todoactivityArray.count; i++) {
        Activity *activity = [[Activity alloc] initWithPropertiesDictionary:_todoactivityArray[i]];
        Item *item = [[Item alloc]init];
        item.itemID=activity.ScheduleID;
        item.title = activity.EventName;
        item.address = activity.Place;
        item.date = activity.Date;
        item.begintime = activity.StartTime;
        item.endtime = activity.EndTime;
        item.isCourse = NO;
        [_todoArray addObject:item];
        
    }

    //加载当天要上的课程
    //条件为当前点击的日期与课程的weekday相同，并且当前周为有课周
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSCalendarUnitWeekdayOrdinal|NSCalendarUnitWeekday)
                       fromDate:[NSDate date]];
    NSInteger weekdayNum = [comps weekday];
    NSString* weekday=[NSString string];
    switch (weekdayNum) {
        case 1:
            weekday=@"sunday";
            break;
        case 2:
            weekday=@"monday";
            break;
        case 3:
            weekday=@"tuesday";
            break;
        case 4:
            weekday=@"wednesday";
            break;
        case 5:
            weekday=@"thursday";
            break;
        case 6:
            weekday=@"friday";
            break;
        case 7:
            weekday=@"saturday";
            break;
        default:
            break;
    }

//    NSDictionary*fetchCourseCondition=[NSDictionary dictionaryWithObjectsAndKeys:weekday,@"weekDay", nil];
//    NSDictionary*courseTimeASC=[NSDictionary dictionaryWithObjectsAndKeys:@"ASC",@"lesson", nil];
    NSString*clickedWeek=[self calculateClickedTimeWeek:date];
    NSLog(@"clickedWeek%@",clickedWeek);
    NSDictionary*fetchedCourses=[[databaseService shareddatabaseService]getCourseFromTableWithWeekday:weekday Week:clickedWeek];
    

    _todocourseArray = [[NSMutableArray alloc] init];
    for (int i=1; i<=[fetchedCourses count]; i++) {
        NSDictionary*coursetemp=[fetchedCourses objectForKey:[NSString stringWithFormat:@"%d",i]];
        [_todoactivityArray addObject:coursetemp];
    }
    for (int i = 0; i < _todocourseArray.count; i++) {
        WeekCourse *weekcourse = [[WeekCourse alloc] initWithPropertiesDictionary:_todocourseArray[i]];
        Item *item = [[Item alloc]init];
        item.itemID= weekcourse.CourseID;
        item.title = weekcourse.CourseName;
        item.address = weekcourse.Place;
      //  item.date = weekcourse.date;
        item.begintime = [NSString stringWithFormat:@"%@－%d节",weekcourse.lesson,weekcourse.lesson.intValue +weekcourse.lessonNum.intValue];
        item.isCourse = YES;
        [_todoArray addObject:item];
    }
    
}


-(NSString*)calculateClickedTimeWeek:(NSDate*)date{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //获取当前周，然后计算点击时间为第几周，是否为无课周，来取得当前的课程信息
    NSString *currentWeek = [userDefaults objectForKey:@"currentWeek"];
    NSLog(@"currentweek%@",currentWeek);
    
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2]; //1代表周日，2代表周一
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:now];
    // 得到周几
    NSInteger weekDay = [components weekday];
    // 得到几号
    NSInteger day = [components day];
    //计算当前日期和周一差的天数:周一－当前日期
    long firstDiff;
    if (weekDay == 1) {
        firstDiff = 1-7;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
    }
    NSLog(@"firstdiff%ld",firstDiff);
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSString*firstday=[NSString stringWithFormat:@"%ld.%ld.%ld",(long)[firstDayComp year],(long)[firstDayComp month],(long)[firstDayComp day]];
    NSLog(@"firstday%@",firstday);
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *firstdate=[formatter dateFromString:firstday];
    
    
    NSDateComponents *diffcomponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date toDate:firstdate options:0];
    NSInteger diffdays = [diffcomponents day];
    NSLog(@"diffdays%ld",(long)diffdays);
    NSInteger num=diffdays/7;
    
    return [NSString stringWithFormat:@"%ld",(long)num+currentWeek.intValue];

    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _todoArray.count;
   
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ActivityItemCell";
    ActivityItemCell *cell = (ActivityItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityItemCell" owner:self options:nil] lastObject];
    }
    
    Item *item = _todoArray[indexPath.row];
    NSString *titletext = [NSString stringWithFormat:@"%@",item.title];
    NSString *addresstext = [NSString stringWithFormat:@"%@",item.address];
    NSString *timetext = [NSString stringWithFormat:@"%@",item.begintime];

    cell.tag = indexPath.row;
    cell.delegate = self;
    cell.titleLabel.text = titletext;
    cell.timeLabel.text = timetext;
    cell.addressLabel.text = addresstext;
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// 选中某个事项cell，进入 事项详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Item *item = _todoArray[indexPath.row];
    
    if(item.isCourse){
        AddedCourseDetailVC *coursedetail = [[AddedCourseDetailVC alloc]init];
        
        NSDictionary*fetchIdCondition=[NSDictionary dictionaryWithObjectsAndKeys:item.itemID,@"CourseID", nil];
        NSDictionary*results=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbCourse" WithCondition:fetchIdCondition];
        NSDictionary*coursetoSendDic=[results allValues][0];
        coursedetail.weekcourse=[[WeekCourse alloc]initWithPropertiesDictionary:coursetoSendDic];
        
        [self.navigationController pushViewController:coursedetail animated:YES];
        
    }else{
        ActivityDetailViewController *activitydetail = [[ActivityDetailViewController alloc]init];

        NSDictionary*fetchIdCondition=[NSDictionary dictionaryWithObjectsAndKeys:item.itemID,@"ScheduleID", nil];
        NSDictionary*results=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbSchedule" WithCondition:fetchIdCondition];
        NSDictionary*activitytoSendDic=[results allValues][0];
        activitydetail.activity=[[Activity alloc]initWithPropertiesDictionary:activitytoSendDic];
        activitydetail.row=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
        [self.navigationController pushViewController:activitydetail animated:YES];
    }
    
}

-(void)reloadCalendarData:(NSNotification*)notification{

    NSDate* obj=[notification object];
    NSLog(@"fetchSchedule%@",obj);
    [self loadCanlendarDataWithDate:obj];
    [itemtableView reloadData];
}
-(void)CalendarTableviewDeleteItem:(NSNotification*)notification{
    NSString* obj=[notification object];
    [_todoArray removeObjectAtIndex:[obj integerValue]];
    [itemtableView reloadData];
}


@end
