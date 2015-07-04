//
//  AddActivityViewController.m
//  Calendar
//
//  Created by emma on 15/6/3.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "AddActivityViewController.h"
#import "ToolMethod.h"
#import "databaseService.h"

@interface AddActivityViewController ()

@end

@implementation AddActivityViewController
CGFloat editmoveup;
CGFloat editfieldwidth;
CGFloat editfieldheight;


-(instancetype)init{
    self=[super init];
    self.view.backgroundColor=[UIColor whiteColor];
    self.hidesBottomBarWhenPushed=YES;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.activity=[[Activity alloc] init];
    // Do any additional setup after loading the view.
    self.title = @"添加事项";
    
    editscroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [editscroll addGestureRecognizer:tap];
    [self.view addSubview:editscroll];

    CGFloat padding = 20;
    
    UILabel *activitytitleLabel =  [[UILabel alloc]initWithFrame:CGRectMake(30, 20, 0, 0)];
    activitytitleLabel.text = @"名    称:";
    [activitytitleLabel sizeToFit];
  //  activitytitleLabel.font = [UIFont systemFontOfSize:18];
    editfieldwidth = ScreenWidth - activitytitleLabel.frame.size.width-60;
    editfieldheight = activitytitleLabel.frame.size.height+10;
    [editscroll addSubview:activitytitleLabel];
    
    titlefield=[self setTextField:activitytitleLabel text:nil tag:200];


    UILabel *date = [self setLabel:activitytitleLabel text:@"日    期:"];
    datefield = [self setTextField:date text:nil tag:201];
    datefield.keyboardType = UIKeyboardTypeDecimalPad;
    
    UILabel *address =[ self setLabel:date text:@"地    点:"];
    addressfield = [self setTextField:address text:nil tag:102];
    addressfield.keyboardType=UIKeyboardTypeASCIICapable;
    
    UILabel *sponsor =[ self setLabel:address text:@"发起者:"];
    sponsorfield = [self setTextField:sponsor text:nil tag:203];
    sponsorfield.keyboardType=UIKeyboardTypeASCIICapable;
    
    
    UILabel *detail = [self setLabel:sponsor text:@"详    情:"];
    UITextField *backgroundfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, editfieldheight*5)];
    [ToolMethod setUiViewLocatin:detail settedView:backgroundfield relativeBasePoint:LeftBottom settedBasePoint:LeftTop offset:CGPointMake(0,20)];
    [editscroll addSubview:backgroundfield];
    backgroundfield.borderStyle=UITextBorderStyleRoundedRect;
    detailfield = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, editfieldheight*5)];
    detailfield.font = detail.font;
    detailfield.delegate = self;
    detailfield.tag = 204;
    detailfield.text = nil;
    detailfield.backgroundColor = [UIColor clearColor];
    [ToolMethod setUiViewLocatin:detail settedView:detailfield relativeBasePoint:LeftBottom settedBasePoint:LeftTop offset:CGPointMake(0,20)];
    [editscroll addSubview:detailfield];
    
    
    UILabel *activitytimeLabel = [self setLabel:detailfield text:@"时    间:"];
    //activitytimeLabel.font = [UIFont systemFontOfSize:15];

    //设定按钮
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setBtn.frame = CGRectMake(self.view.frame.size.width - padding - 50, CGRectGetMinY(activitytimeLabel.frame), 50 , editfieldheight);
    setBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    setBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [setBtn setTitle:@"设定" forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(clicksetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [editscroll addSubview:setBtn];
    

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titlefield.frame), CGRectGetMinY(activitytimeLabel.frame), 100, editfieldheight)];
    [editscroll addSubview:self.timeLabel];
    //    NSString *begintime = self.activity.begintime;
    //    NSString *endtime = self.activity.endtime;
    //    self.timeLabel.text = [NSString stringWithFormat:@"%@~%@",begintime, endtime];
    
    self.timeLabel.text = @"00:00~00:00";  // 默认时间
    self.timeLabel.backgroundColor = [UIColor lightGrayColor];
    [editscroll addSubview:self.timeLabel];
    
    CGFloat contentheight = editscroll.frame.size.height > detailfield.frame.origin.y+ detailfield.frame.size.height+20?editscroll.frame.size.height: detailfield.frame.origin.y+ detailfield.frame.size.height+20;
    editscroll.contentSize = CGSizeMake(ScreenWidth,contentheight);
    

    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(addActivity)];
}




-(UILabel*)setLabel:(UILabel*)uplabel text:(NSString*)text {
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
    label.text=text;
    [label sizeToFit];
    [ToolMethod setUiViewLocatin:uplabel settedView:label relativeBasePoint:LeftBottom settedBasePoint:LeftTop offset:CGPointMake(0, 20)];
    [editscroll addSubview:label];
    return label;
    
}

-(UITextField*)setTextField:(UILabel*)leftlabel text:(NSString*)text tag:(NSInteger)tag{
    UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, editfieldwidth, editfieldheight)];
    textfield.borderStyle=UITextBorderStyleRoundedRect;
    if(text)
        textfield.text=text;
    textfield.returnKeyType=UIReturnKeyNext;
    textfield.autocapitalizationType=UITextAutocapitalizationTypeNone;
    textfield.tag=tag;
    textfield.delegate=self;
    [ToolMethod setUiViewLocatin:leftlabel settedView:textfield relativeBasePoint:RightCenter settedBasePoint:LeftCenter offset:CGPointMake(10,0)];
    [editscroll addSubview:textfield];
    return textfield;
}
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];

    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

-(void)addActivity
{
    NSDate*currentTime=[NSDate date];
    NSString*activityIdByTime=[self stringFromDate:currentTime];
    if ([self.viewIndex isEqualToString:@"0"]) {
        NSDictionary*activityDic=[NSDictionary dictionaryWithObjectsAndKeys:activityIdByTime,@"ScheduleID",titlefield.text,@"EventName",@"0",@"Status", datefield.text,@"Date",addressfield.text,@"Place",sponsorfield.text,@"sponsor",@"1",@"ShouldRemind",@"17:00",@"RemindTime",detailfield.text,@"Description",@"",@"Duration",@"",@"Companion",@"",@"frequency",self.activity.StartTime,@"StartTime",self.activity.EndTime,@"EndTime",nil];
            [[databaseService shareddatabaseService]insert:activityDic toTable:@"dbSchedule"];
    }else{
        NSDictionary*activityDic=[NSDictionary dictionaryWithObjectsAndKeys:activityIdByTime,@"ScheduleID",titlefield.text,@"EventName",@"1",@"Status", datefield.text,@"Date",addressfield.text,@"Place",sponsorfield.text,@"sponsor",@"1",@"ShouldRemind",@"17:00",@"RemindTime",detailfield.text,@"Description",@"",@"Duration",@"",@"Companion",@"",@"frequency",self.activity.StartTime,@"StartTime",self.activity.EndTime,@"EndTime",nil];
            [[databaseService shareddatabaseService]insert:activityDic toTable:@"dbSchedule"];
    }

    NSString*activityIdToSend=[NSString stringWithString:activityIdByTime];



    
    if ([self.viewIndex isEqualToString:@"0"]) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"addTodoScheduleNotification" object:activityIdToSend];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addFavouriteScheduleNotification" object:activityIdToSend];
        }
    [self.navigationController popViewControllerAnimated:YES];
}





-(void)clicksetBtn:(id)sender{
    NSLog(@"时间设定");
    ActivityTimePickerView *pickerView = [[ActivityTimePickerView alloc] initWithTitle:@"时间设定" delegate:self];
    if (self.timeLabel.text) {
//        pickerView.activity = self.activity;
    }
    [pickerView showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ActivityTimePickerView *pickerView = (ActivityTimePickerView *)actionSheet;
    self.activity.StartTime = pickerView.startTime;
    self.activity.EndTime = pickerView.endTime;
    
    if(buttonIndex == 0) {
        NSLog(@"Cancel");
    }else {
        NSLog(@"Select%@~%@",self.activity.StartTime, self.activity.EndTime);
        self.timeLabel.text = [NSString stringWithFormat:@"%@~%@",self.activity.StartTime, self.activity.EndTime];
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    editcurrentView = textView;
    [self keyboardWillShow];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    editcurrentView = textField;
    [self keyboardWillShow];
    return YES;
}

-(void)click{
    if([editcurrentView isFirstResponder]){
        [editcurrentView resignFirstResponder];
        editcurrentView = nil;
        [self keyboardWillHide];
    }
}
- (void)keyboardWillShow {
    CGFloat currentViewBottom = editcurrentView.frame.origin.y + editcurrentView.frame.size.height;
    if(currentViewBottom > ScreenHeight-64-250){
        editmoveup=currentViewBottom - ScreenHeight+64+250;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        editscroll.contentOffset = CGPointMake(editscroll.contentOffset.x, editscroll.contentOffset.y+ editmoveup);
        [UIView commitAnimations];
    }
}
- (void)keyboardWillHide {
    
    if(editmoveup!=0){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        editscroll.contentOffset=CGPointMake(editscroll.contentOffset.x, editscroll.contentOffset.y- editmoveup);
        [UIView commitAnimations];
        editmoveup=0;
    }
}

@end
