//
//  imagedisplayCellTableViewCell.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "imagedisplayCell.h"

#define kStatusTableViewCellControlSpacing 10//控件间距
#define kStatusTableViewCellscrollerviewWidth 355 //button宽度
#define kStatusTableViewCellscrollerviewHeight 200 //button宽度

@interface imagedisplayCell()
{
    NSTimer *timer;
    UIScrollView *imagedisplay;
    UIPageControl *pagecontrol;
}

@end
@implementation imagedisplayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
        // Initialization code
    }
    return self;
}

#pragma mark 初始化视图
- (void)initSubview{
    //头像控件
    imagedisplay = [[UIScrollView alloc]init];
    [self addSubview:imagedisplay];
    
    //    CGFloat scrollerViewX = 10,scrollerViewY = 10;
    CGRect scrollviewRect = CGRectMake(kStatusTableViewCellControlSpacing, kStatusTableViewCellControlSpacing, kStatusTableViewCellscrollerviewWidth, kStatusTableViewCellscrollerviewHeight);
    imagedisplay.frame = scrollviewRect;
    imagedisplay.backgroundColor=[UIColor clearColor];
    imagedisplay.showsHorizontalScrollIndicator=NO;
    
    
    //    _height = CGRectGetMaxY(imagedisplay.frame) + kStatusTableViewCellControlSpacing;
    pagecontrol=[[UIPageControl alloc]init];

    [self addSubview:pagecontrol];
    CGRect pagecontrolrect =CGRectMake(kStatusTableViewCellControlSpacing, CGRectGetMaxY(imagedisplay.frame), kStatusTableViewCellscrollerviewWidth, 10);
    pagecontrol.frame=pagecontrolrect;
    pagecontrol.backgroundColor=[UIColor lightGrayColor];
    CGFloat imageW=imagedisplay.frame.size.width;
    CGFloat imageH=imagedisplay.frame.size.height;
    CGFloat imageY=0;
    NSInteger imageNum=5;
    pagecontrol.numberOfPages=imageNum;
    pagecontrol.currentPage=0;

    for (int i=0; i<imageNum; i++) {
        UIImageView *imageView=[[UIImageView alloc]init];
        CGFloat imageX=imageW*i ;
        imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
        
        //设置图片名称并对应于相应的图片
        NSString *name = [NSString stringWithFormat:@"display_0%d.png", i + 1];
        imageView.image = [UIImage imageNamed:name];
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer*tapImgGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImgDetail)];
        [imageView addGestureRecognizer:tapImgGes];
    
        [imagedisplay addSubview:imageView];
    }
    
    
    CGFloat contentW=imageNum*imageW;
    imagedisplay.contentSize=CGSizeMake(contentW, 0);
    imagedisplay.pagingEnabled=YES;
    
    imagedisplay.delegate=self;
    [self addTimer];
    
}


-(void)showImgDetail{
    UITableViewController*ImgDetail=[[UITableViewController alloc] init];
    [self.delegate showDetail:ImgDetail];

}


-(void)nextImage
{
    NSInteger page=pagecontrol.currentPage;
    if(page==4){
        page=0;
    }else{page++;}
    CGFloat x=page*imagedisplay.frame.size.width;
    imagedisplay.contentOffset=CGPointMake(x, 0);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //计算页码，用于pagecontrol显示
    CGFloat scrollviewW=imagedisplay.frame.size.width;
    CGFloat scrollviewoffset=imagedisplay.contentOffset.x;
    NSInteger page=(scrollviewoffset+scrollviewW/2)/scrollviewW;
    pagecontrol.currentPage=page;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

-(void)addTimer
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)removeTimer
{
    [timer invalidate];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
