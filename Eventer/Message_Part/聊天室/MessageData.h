

#import <Foundation/Foundation.h>

@interface MessageData : NSObject

@property (nonatomic, strong) NSString *messageGroupId;
@property (nonatomic, strong) NSString *posterId;
@property (nonatomic, strong) NSString *catcherId;
@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic, assign) NSInteger mediaType;
@property (nonatomic, strong) NSString *img;

- (instancetype)initWithMsgId:(NSString *)msgId messageGroupId:(NSString *)messageGroupId posterId:(NSString *)posterId catcherId:(NSString*)catcherId text:(NSString *)text date:(NSDate *)date msgType:(NSInteger)msgType mediaType:(NSInteger)medType img:(NSString *)img;

@end
