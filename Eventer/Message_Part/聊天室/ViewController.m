

#import "ViewController.h"
#import "MessageData.h"
#import "databaseService.h"
#import "messageViewController.h"

#define admin @"10001"
@interface ViewController () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong,nonatomic)NSMutableArray*dicArray;
@property (nonatomic,strong) UIImage *willSendImage;


@end

@implementation ViewController

@synthesize messageArray;
-(id)init
{
    self=[super init];
    self.title=self.name;
    self.hidesBottomBarWhenPushed=YES;
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{

    [super viewDidLoad];
    
     self.title = self.name;
    
    self.delegate = self;
    self.dataSource = self;
    
    self.messageArray = [NSMutableArray array];
//    //时间间隔
//    NSTimeInterval timeInterval =15 ;
//    //定时器
//    NSTimer*saveTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
//                                                         target:self
//                                                       selector:@selector(saveWithInterval:)
//                                                       userInfo:nil
//                                                        repeats:YES];

    [self loadData];
    NSTimeInterval timeInterval =10 ;
    NSTimer * persontotalk=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(receivemessage:) userInfo:nil repeats:YES];
}

-(void)receivemessage:(NSTimer*)timer
{
    NSDate*date=[NSDate date];
    NSString*currentTime=[self stringFromDate:date];
    
    MessageData *message =[[MessageData alloc]initWithMsgId:currentTime messageGroupId:self.messageGroupId posterId:self.participantId catcherId:admin text:@"This is a Chat Demo like iMessage.app" date:date msgType:JSBubbleMessageTypeIncoming mediaType:JSBubbleMediaTypeText img:self.avatar];
    

    [self.messageArray addObject:message];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSDictionary*UserCondition=[NSDictionary dictionaryWithObjectsAndKeys:admin,@"catcherId",self.messageGroupId,@"messageGroupId", nil];


    [[databaseService shareddatabaseService]deleteFrom:@"dbMessage" WithCondition:UserCondition];

    
    for (id obj in self.messageArray) {
        NSDictionary*temp=[self translateintoDic:obj];
        [[databaseService shareddatabaseService]insert:temp toTable:@"dbMessage"];
    }
        MessageData*lastItem=[self.messageArray lastObject];
    if (lastItem) {
        NSDictionary*NameCondition=[NSDictionary dictionaryWithObject:self.name forKey:@"name"];
//        if ([[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"chatRecord" WithCondition:NameCondition] count]>0) {
//            NSDictionary*changes=[NSDictionary dictionaryWithObjectsAndKeys:lastItem.text,@"lastmsg",lastItem.date,@"time", nil];
//            [[databaseService shareddatabaseService]updateTable:@"chatRecord" WithChanges:changes AndConditions:NameCondition];
////            NSDictionary*infoToSend=[NSDictionary dictionaryWithObjectsAndKeys:@"",@"indexpath", nil]
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateChatRecordNotification" object:changes];
//        }else{

//        NSDictionary*chatItem=[NSDictionary dictionaryWithObjects:@[self.name,self.participantId,self.avatar,lastItem.text,lastItem.date] forKeys:@[@"name",@"participantId",@"avatar",@"lastmsg",@"time"]];
        
        NSDictionary*chatItem=[NSDictionary dictionaryWithObjects:@[self.name,self.participantId,self.avatar,lastItem.text,lastItem.date] forKeys:@[@"name",@"participantId",@"avatar",@"lastMsg",@"time"]];
        
        
        [[databaseService shareddatabaseService]insert:chatItem toTable:@"chatRecord"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addChatRecordNotification" object:chatItem];
//        }
    }
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:NO];

}


//-(void)saveWithInterval:(NSTimer *)timer
//{
//    for (id obj in self.messageArray) {
//        NSDictionary*temp=[self translateintoDic:obj];
//        [[databaseService shareddatabaseService]insert:temp toTable:@"dbMessage"];
//    }
//}

- (void)loadData{

    NSDictionary*order=[NSDictionary dictionaryWithObject:@"ASC" forKey:@"date"];
    NSDictionary*Condition=[NSDictionary dictionaryWithObjectsAndKeys:self.messageGroupId,@"messageGroupId", nil];

    NSDictionary*results=[[databaseService shareddatabaseService]get:@"ALL" FromTable:@"dbMessage" WithCondition:Condition orderby:order ];
    for (int i=1; i<=[results count]; i++) {
        MessageData*mes=[[MessageData alloc]init];
        NSDictionary*messageitem=[results objectForKey:[NSString stringWithFormat:@"%d",i]];
        mes.msgId=[messageitem objectForKey:@"msgId"];
        mes.posterId=[messageitem objectForKey:@"posterId"];
        mes.catcherId=[messageitem objectForKey:@"catcherId"];
        mes.text=[messageitem objectForKey:@"text"];

        mes.date=[self NSStringToNSDateWithString:[messageitem objectForKey:@"date"]];
        mes.messageType=[[messageitem objectForKey:@"messageType"]integerValue];
        mes.mediaType=[[messageitem objectForKey:@"mediaType"]integerValue];
        mes.img=[messageitem objectForKey:@"img"];
        NSLog(@"neirong:%@type:%ld%@",mes.text,(long)mes.messageType,mes.msgId);
        [self.messageArray addObject:mes];
    }

//    NSArray*messages=[results allValues];
//    for (NSDictionary*obj in messages) {
//        MessageData*mes=[[MessageData alloc]initWithMsgId:obj[@"MsgId"] posterId:obj[@"poster"]  catcherId:obj[@"catcherId"] text:obj[@"text"] date:obj[@"date"] msgType:[obj[@"msgType"]integerValue] mediaType:[obj[@"mediaType"]integerValue] img:obj[@"img"]];
//        [self.messageArray addObject:mes];
//    }
    [self.tableView reloadData];
}

-(NSDate*)NSStringToNSDateWithString:(NSString*)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *date = [dateFormatter dateFromString:@"2010-08-04 16:01:03"];
    NSLog(@"%@", date);
    return [date copy];
}



-(NSMutableDictionary*)translateintoDic:(MessageData*)msg
{
    NSMutableDictionary*dic=[NSMutableDictionary dictionary];
    [dic setObject:msg.messageGroupId forKey:@"messageGroupId"];
    [dic setObject:msg.msgId forKey:@"msgId"];
    [dic setObject:msg.posterId forKey:@"posterId"];
    [dic setObject:msg.messageGroupId forKey:@"messageGroupId"];
    if (msg.text!=nil){
        [dic setObject:msg.catcherId forKey:@"catcherId"];
    }
    if (msg.text!=nil) {
        [dic setObject:msg.text forKey:@"text"];
    }
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)msg.messageType] forKey:@"messageType"];
    NSString*date=[self stringFromDate:msg.date];
    [dic setObject:date forKey:@"date"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)msg.mediaType]forKey:@"mediaType"];
    return dic;
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    NSDate*currentTime=[NSDate date];
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *msgId = [dateFormatter stringFromDate:currentTime];
    
    JSBubbleMessageType msgType;
    msgType = JSBubbleMessageTypeOutgoing;
    [JSMessageSoundEffect playMessageSentSound];
  
    
    MessageData *message = [[MessageData alloc]initWithMsgId:msgId messageGroupId:[NSString stringWithFormat:@"%@%@",admin,self.participantId] posterId:admin catcherId:self.participantId text:text date:currentTime msgType:msgType mediaType:JSBubbleMediaTypeText img:nil];
                            
                            

    [self.messageArray addObject:message];
    [self finishSend:NO];
}

- (void)cameraPressed:(id)sender{
    
    [self.inputToolBarView.textView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma mark -- UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSDate*currentTime=[NSDate date];
    switch (buttonIndex) {
        case 0:
        case 1:{
            NSDate*date=[NSDate date];
            NSString*currentTime=[self stringFromDate:date];
            
            JSBubbleMessageType msgType;
            msgType = JSBubbleMessageTypeOutgoing;
            [JSMessageSoundEffect playMessageSentSound];

            
            MessageData *message =[[MessageData alloc]initWithMsgId:currentTime messageGroupId:self.messageGroupId posterId:admin catcherId:self.participantId text:nil date:date msgType:msgType mediaType:JSBubbleMediaTypeImage img:@"demo1.jpg"];
            

            [self.messageArray addObject:message];
            [self finishSend:YES];
        }
            break;
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *message = self.messageArray[indexPath.row];
    return message.messageType;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageData *message = self.messageArray[indexPath.row];
    return message.mediaType;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleCircle;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat

     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageData *message = self.messageArray[indexPath.row];
    return message.text;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData *message = self.messageArray[indexPath.row];
    return message.date;
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}

- (SEL)avatarImageForIncomingMessageAction
{
    return @selector(onInComingAvatarImageClick);
}

- (void)onInComingAvatarImageClick
{
    NSLog(@"__%s__",__func__);
}

- (SEL)avatarImageForOutgoingMessageAction
{
    return @selector(onOutgoingAvatarImageClick);
}

- (void)onOutgoingAvatarImageClick
{
    NSLog(@"__%s__",__func__);
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-woz"];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageData *message = self.messageArray[indexPath.row];
    return [UIImage imageNamed:message.img];
}

@end
