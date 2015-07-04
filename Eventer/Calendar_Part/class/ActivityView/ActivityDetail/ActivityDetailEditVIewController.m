//
//  ActivityDetailEditVIewController.m
//  Calendar
//
//  Created by emma on 15/6/16.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "ActivityDetailEditVIewController.h"
#import "ToolMethod.h"
#import "databaseService.h"

@interface ActivityDetailEditVIewController ()

@end

@implementation ActivityDetailEditVIewController

CGFloat fieldwidth;
CGFloat fieldheight;
CGFloat moveup;

-(instancetype)init{
    self=[super init];
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
    self.title = @"编辑事项";

    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [scroll addGestureRecognizer:tap];
    [self.view addSubview:scroll];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, 0, 0)];
    title.text = @"名    称:";
    [title sizeToFit];
    fieldwidth = ScreenWidth - title.frame.size.width-60;
    fieldheight = title.frame.size.height+10;
    [scroll addSubview:title];
    NSLog(@"活动名称%@",self.activity.EventName);
    titlefield=[self setTextField:title text:self.activity.EventName tag:100];
    
    UILabel *date = [self setLabel:title text:@"日    期:"];
    datefield = [self setTextField:date text:self.activity?self.activity.Date:nil tag:101];
    datefield.keyboardType = UIKeyboardTypeDecimalPad;
    
    UILabel *address =[ self setLabel:date text:@"地    点:"];
    addressfield = [self setTextField:address text:self.activity?self.activity.Place:nil tag:102];
    addressfield.keyboardType=UIKeyboardTypeASCIICapable;
    
    UILabel *sponsor =[ self setLabel:address text:@"发起者:"];
    sponsorfield = [self setTextField:sponsor text:self.activity?self.activity.sponsor:nil tag:103];
    sponsorfield.keyboardType=UIKeyboardTypeASCIICapable;


    UILabel *detail=[self setLabel:sponsor text:@"详    情:"];
    UITextField *backgroundfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, fieldheight*5)];
    [ToolMethod setUiViewLocatin:detail settedView:backgroundfield relativeBasePoint:LeftBottom settedBasePoint:LeftTop offset:CGPointMake(0,20)];
    [scroll addSubview:backgroundfield];
    backgroundfield.borderStyle=UITextBorderStyleRoundedRect;
    detailfield = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, fieldheight*5)];
    detailfield.font = detail.font;
    detailfield.delegate = self;
    detailfield.tag = 104;
    detailfield.text = self.activity?self.activity.description:nil;
    detailfield.backgroundColor = [UIColor clearColor];
    [ToolMethod setUiViewLocatin:detail settedView:detailfield relativeBasePoint:LeftBottom settedBasePoint:LeftTop offset:CGPointMake(0,20)];
    [scroll addSubview:detailfield];
    
    CGFloat contentheight = scroll.frame.size.height > detailfield.frame.origin.y+ detailfield.frame.size.height+20?scroll.frame.size.height: detailfield.frame.origin.y+ detailfield.frame.size.height+20;
    scroll.contentSize = CGSizeMake(ScreenWidth,contentheight);
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveActivity)];

}

-(UILabel*)setLabel:(UILabel*)uplabel text:(NSString*)text {
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
    label.text=text;
    [label sizeToFit];
    [ToolMethod setUiViewLocatin:uplabel settedView:label relativeBasePoint:LeftBottom settedBasePoint:LeftTop offset:CGPointMake(0, 20)];
    [scroll addSubview:label];
    return label;
    
}

-(UITextField*)setTextField:(UILabel*)leftlabel text:(NSString*)text tag:(NSInteger)tag{
    UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, fieldwidth, fieldheight)];
    textfield.borderStyle=UITextBorderStyleRoundedRect;
    if(text)
        textfield.text=text;

    textfield.returnKeyType=UIReturnKeyNext;
    textfield.autocapitalizationType=UITextAutocapitalizationTypeNone;
    textfield.tag=tag;
    textfield.delegate=self;
    [ToolMethod setUiViewLocatin:leftlabel settedView:textfield relativeBasePoint:RightCenter settedBasePoint:LeftCenter offset:CGPointMake(10,0)];
    [scroll addSubview:textfield];
    return textfield;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    currentView=textView;
    [self keyboardWillShow];
    return YES;
}

-(void)saveActivity{
    
    NSDictionary*ScheduleToUpdate=[NSDictionary dictionaryWithObjectsAndKeys:titlefield.text,@"EventName",datefield.text,@"Date",addressfield.text,@"Place",detailfield.text,@"Description",sponsorfield.text,@"sponsor",nil];
    NSDictionary*condition=[NSDictionary dictionaryWithObjectsAndKeys:self.activity.EventName,@"EventName", nil];//以后改成ID，先按照名字来搞
    [[databaseService shareddatabaseService]updateTable:@"dbSchedule" WithChanges:ScheduleToUpdate AndConditions:condition];
    self.activity.EventName=titlefield.text;
    self.activity.Place=addressfield.text;
    self.activity.Date=datefield.text;
    self.activity.sponsor=sponsorfield.text;
    self.activity.Description=detailfield.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modifySchedule" object:self.activity];
    [self.navigationController popViewControllerAnimated:YES];

}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    currentView=textField;
    [self keyboardWillShow];
    return YES;
}

-(void)click{
    if([currentView isFirstResponder]){
        [ currentView resignFirstResponder];
        currentView = nil;
        [self keyboardWillHide];
    }
}
- (void)keyboardWillShow {
    CGFloat currentViewBottom = currentView.frame.origin.y+currentView.frame.size.height-scroll.contentOffset.y;
    if(currentViewBottom > ScreenHeight-64-250){
        moveup=currentViewBottom - ScreenHeight+64+250;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        scroll.contentOffset=CGPointMake(scroll.contentOffset.x, scroll.contentOffset.y+moveup);
        [UIView commitAnimations];
    }
}
- (void)keyboardWillHide {
    
    if(moveup!=0){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        scroll.contentOffset=CGPointMake(scroll.contentOffset.x, scroll.contentOffset.y-moveup);
        [UIView commitAnimations];
        moveup=0;
    }
}

@end
