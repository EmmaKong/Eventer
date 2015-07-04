//
//  SliderViewController.m
//  Eventer
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "SliderViewController.h"
#import "SliderCollectionViewCell.h"
#import "sectionViewController.h"
#import "databaseService.h"
#define kIndexCell @"SliderCollectionViewCell"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SliderViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>


@property(assign,nonatomic) CGFloat topWidth;

@property(strong,nonatomic) UIScrollView * sliderView;

@property(assign,nonatomic) CGFloat offSet;
@end

@implementation SliderViewController
-(SliderViewController*)init{
    self=[super init];
    self.title=@"更多";
    self.hidesBottomBarWhenPushed=YES;
    return self;
}
- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _viewControllers = [viewControllers copy];
        
        self.selectIndex=0;
        
        // _selectedIndex = NSNotFound;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchevent)];
    
    NSMutableArray * array=[NSMutableArray array];
    NSArray * titiles=@[@"推荐",@"学习",@"求职",@"娱乐",@"生活"];
    for (int i=0; i<titiles.count; i++) {
        sectionViewController * nex=[[sectionViewController alloc] init];
        
        switch (i) {
            case 0:
                nex.view.backgroundColor=[UIColor clearColor];
                
                break;
            case 1:
                nex.view.backgroundColor=[UIColor clearColor];
                
                break;
            case 2:
                nex.view.backgroundColor=[UIColor clearColor];
                
                break;
            case 3:
                nex.view.backgroundColor=[UIColor clearColor];
                
                break;
            case 4:
                nex.view.backgroundColor=[UIColor clearColor];
                
                break;
                
            default:
                break;
        }
        [array addObject:nex];
    }
    
    
    // SliderViewController * next=[[SliderViewController alloc] initWithViewControllers:array];
    [self initWithViewControllers:array];
    self.titileArray=titiles;
    self.selectColor=[UIColor greenColor];
    self.selectIndex=0;
    
    
    
    self.title=@"更多";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.offSet=64;
    
    self.topWidth=80;
    
    if (self.titileArray.count<6) {
        self.topWidth=kScreenWidth/self.titileArray.count;
    }
    if (_isNeedCustomWidth) {
        self.topWidth=100;
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;
    flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    self.colletionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,self.offSet,kScreenWidth,kTopViewHeight) collectionViewLayout:flowLayout];
    
    self.colletionView.delegate=self;
    self.colletionView.dataSource=self;
    
    self.colletionView.showsHorizontalScrollIndicator=NO;
    UINib *nib=[UINib nibWithNibName:kIndexCell bundle:nil];
    
    [self.colletionView registerNib: nib forCellWithReuseIdentifier:kIndexCell];
    
    
    UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colletionView.frame)-0.5, kScreenWidth, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    [self.view addSubview:self.colletionView];
    
    CGRect frame = CGRectMake(self.indicatorInsets.left, kTopViewHeight-INDICATOR_HEIGHT+0.5, self.topWidth, INDICATOR_HEIGHT);
    _indicator = [[UIView alloc] initWithFrame:frame];
    _indicator.backgroundColor=self.selectColor;
    [self.colletionView addSubview:self.indicator];
    
    
    self.colletionView.backgroundColor=[UIColor clearColor];
    
    self.sliderView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colletionView.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(self.colletionView.frame))];
    self.sliderView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_sliderView];
    
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[UITableViewController class]]) {
            UITableViewController * vc=obj;
            CGRect newFrame=vc.view.frame;
            newFrame.size.height=CGRectGetHeight(self.sliderView.frame);
            newFrame.origin.x+=idx*CGRectGetWidth(self.sliderView.frame);
            newFrame.origin.y=0;
            vc.view.frame=newFrame;
            // vc.view.backgroundColor=[UIColor grayColor];
            [self.sliderView addSubview:vc.view];
            
        }
    }];
    
    self.sliderView.delegate=self;
    self.sliderView.pagingEnabled=YES;
    self.sliderView.bounces=NO;
    self.sliderView.contentSize=CGSizeMake(CGRectGetWidth(self.sliderView.frame)*self.viewControllers.count, CGRectGetHeight(self.sliderView.frame));
    self.sliderView.showsHorizontalScrollIndicator=NO;
    
    if (self.selectIndex>0) {
        
        [self silderWithIndex:self.selectIndex isNeedScroller:NO];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setSelectColor:(UIColor *)selectColor{
    _selectColor=selectColor;
    
    
}

#pragma mark---顶部的滑动试图
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // return allSpaces.count;
    return self.titileArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self silderWithIndex:indexPath.row isNeedScroller:NO];
    
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SliderCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kIndexCell forIndexPath:indexPath];
    UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(self.topWidth-0.5, 0,0.5 ,CGRectGetHeight(cell.frame)-0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    
    if (!_isNeedCustomWidth) {
        [cell insertSubview:line atIndex:cell.subviews.count-1];
        
    }
    
    cell.titile.text=self.titileArray[indexPath.row];
    
    if (self.selectIndex==indexPath.row) {
        cell.titile.textColor=self.selectColor;
    }
    else{
        cell.titile.textColor=[UIColor blackColor];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(_topWidth, 44);
}


-(void)silderWithIndex:(NSInteger)index isNeedScroller:(BOOL)isNeed{
    
    //[self.view endEditing:YES];
    databaseService* sqlmanager=[[databaseService alloc]init];
    [sqlmanager useDatabaseWithName:@"eventer.db"];
    NSString*temp=[NSString stringWithFormat: @"%ld", (long)index];
    NSDictionary*condition=[NSDictionary dictionaryWithObject:temp forKey:@"ztype"];
    NSDictionary*order=[NSDictionary dictionaryWithObjectsAndKeys:@"DESC",@"zpubtime",@"ASC",@"zsource", nil];
    NSDictionary*result=[sqlmanager get:@"ALL" FromTable:@"dbEvent" WithCondition:condition orderby:order];
    NSArray*array=[NSArray arrayWithArray:[result allValues]];
    
    sectionViewController*sectionvc= self.viewControllers[index];
    sectionvc.datatoload=array;
    [sectionvc reload];
    
    self.selectIndex=index;
    
    [UIView animateWithDuration:0.1*(abs((int)(self.selectIndex-index))) animations:^{
        CGRect newframe=self.indicator.frame;
        newframe.origin.x=self.topWidth*index;
        self.indicator.frame=newframe;
        
    }];
    
    if (isNeed) {
        [self.colletionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else{
        [self.sliderView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];
        
    }
    
    
    
    [self.colletionView reloadData];
    
    
    //    if (self.sliderDelegate) {
    //        [self.sliderDelegate sliderScrollerDidIndex:index andSlider:self];
    //    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.sliderView]) {
        NSInteger index=scrollView.contentOffset.x/kScreenWidth;
        
        if (index!=self.selectIndex) {
            [self silderWithIndex:index isNeedScroller:YES];
        }
    }
}
-(id)getSelectSlider{
    return self.viewControllers[self.selectIndex];
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