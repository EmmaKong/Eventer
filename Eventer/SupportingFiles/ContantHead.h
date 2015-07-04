//
//  ContantHead.h
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#ifndef Eventer_ContantHead_h
#define Eventer_ContantHead_h

typedef NS_ENUM(NSInteger, GestureType) {
    
    TapGesType = 1,
    LongGesType,
    
};

#define TableHeader 50
#define eventImgHeight 50
#define ShowImage_H 80
#define PlaceHolder @" "
#define offSet_X 20
#define EmotionItemPattern    @"\\[em:(\\d+):\\]"


#define kReplyBtnDistance 8 //回复按钮距离
#define kReply_FavourDistance 8 //回复按钮到点赞的距离
#define AttributedImageNameKey      @"ImageName"
#define marginspace 15
#define topmargin 10
#define commonOffset_X 2*marginspace + TableHeader
#define commonWidth screenWidth-TableHeader-marginspace*3

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

#define limitline 4
#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色

#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色

#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

#define WS(weakSelf)  __weak __typeof(self)weakSelf = self;





#define KColor(r,g,b)  [UIColor colorWithHue:r/255.0 saturation:g/255.0 brightness:b/255.0 alpha:1]
#define kStatusTableViewCellControlSpacing 10//控件间距
#define kStatusTableViewCellBackgroundColor KColor(251,251,251)
#define kStatusGrayColor KColor(50,50,50)
#define kStatusLightGrayColor KColor(120,120,120)

#define kStatusTableViewCellAvatarWidth 40 //头像宽度
#define kStatusTableViewCellAvatarHeight kStatusTableViewCellAvatarWidth
#define kStatusTableViewCellUserNameFontSize 14
#define kStatusTableViewCellMbTypeWidth 13 //会员图标宽度
#define kStatusTableViewCellMbTypeHeight kStatusTableViewCellMbTypeWidth
#define kStatusTableViewCellCreateAtFontSize 12
#define kStatusTableViewCellTextFontSize 14


#define kLocationToBottom 5



#endif
