//
//  Calendar.m
//  Calendar
//
//  Created by emma on 15/6/13.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "Calendar.h"
#import "CalendarHeader.h"
#import "UIView+Extension.h"
#import "NSDate+Extension.h"
#import "NSCalendar+Extension.h"
#import "CalendarCell.h"

#define kWeekHeight roundf(self._height/9)
#define kBlueText   [UIColor colorWithRed:14/255.0  green:69/255.0  blue:221/255.0    alpha:1.0]
#define kPink       [UIColor colorWithRed:198/255.0 green:51/255.0  blue:42/255.0     alpha:1.0]
#define kBlue       [UIColor colorWithRed:31/255.0  green:119/255.0 blue:219/255.0    alpha:1.0]

@interface Calendar (DataSourceAndDelegate)

- (BOOL)hasEventForDate:(NSDate *)date;
- (NSString *)subtitleForDate:(NSDate *)date;

- (BOOL)shouldSelectDate:(NSDate *)date;
- (void)didSelectDate:(NSDate *)date;
- (void)currentMonthDidChange;

@end

@interface Calendar ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray             *weekdays;

@property (strong, nonatomic) NSMutableDictionary        *backgroundColors;
@property (strong, nonatomic) NSMutableDictionary        *titleColors;
@property (strong, nonatomic) NSMutableDictionary        *subtitleColors;

@property (weak,   nonatomic) CALayer                    *topBorderLayer;
@property (weak,   nonatomic) CALayer                    *bottomBorderLayer;
@property (weak,   nonatomic) UICollectionView           *collectionView;
@property (weak,   nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (copy,   nonatomic) NSDate                     *minimumDate;
@property (copy,   nonatomic) NSDate                     *maximumDate;

@property (assign, nonatomic) BOOL                       supressEvent;

- (void)adjustTitleIfNecessary;

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForDate:(NSDate *)date;

- (void)scrollToDate:(NSDate *)date;
- (void)scrollToDate:(NSDate *)date animate:(BOOL)animate;

- (void)setSelectedDate:(NSDate *)selectedDate animate:(BOOL)animate;

@end

@implementation Calendar

@synthesize flow = _flow, firstWeekday = _firstWeekday;

#pragma mark - Life Cycle && Initialize

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize  // 初始化
{
    CGRect frame = CGRectMake(0, -35, self.frame.size.width, 35);
    
    self.header = [[CalendarHeader alloc] initWithFrame:(CGRect)frame];
    [self addSubview:self.header];

    _titleFont        = [UIFont systemFontOfSize:15];
    _subtitleFont     = [UIFont systemFontOfSize:10];
    _weekdayFont      = [UIFont systemFontOfSize:15];
    _headerTitleFont  = [UIFont systemFontOfSize:15];
    _headerTitleColor = kBlueText;
    
    NSArray *weekSymbols = [[NSCalendar _sharedCalendar] shortStandaloneWeekdaySymbols];
    _weekdays = [NSMutableArray arrayWithCapacity:weekSymbols.count];
    for (int i = 0; i < weekSymbols.count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        weekdayLabel.text = weekSymbols[i];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.font = _weekdayFont;
        weekdayLabel.textColor = kBlueText;
        [_weekdays addObject:weekdayLabel];
        [self addSubview:weekdayLabel];
    }
    
    _flow         = CalendarFlowHorizontal; // 水平滚动
    _firstWeekday = [[NSCalendar _sharedCalendar] firstWeekday];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewFlowLayout.minimumInteritemSpacing = 0;
    collectionViewFlowLayout.minimumLineSpacing = 0;
    self.collectionViewFlowLayout = collectionViewFlowLayout;
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:collectionViewFlowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = YES;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delaysContentTouches = NO;
    collectionView.canCancelContentTouches = YES;
    [collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    _currentDate = [NSDate date];
    _currentMonth = [_currentDate copy];
    
    _backgroundColors = [NSMutableDictionary dictionaryWithCapacity:4];
    _backgroundColors[@(CalendarCellStateNormal)]      = [UIColor clearColor];
    _backgroundColors[@(CalendarCellStateSelected)]    = kBlue;
    _backgroundColors[@(CalendarCellStateDisabled)]    = [UIColor clearColor];
    _backgroundColors[@(CalendarCellStatePlaceholder)] = [UIColor clearColor];
    _backgroundColors[@(CalendarCellStateToday)]       = kPink;
    
    _titleColors = [NSMutableDictionary dictionaryWithCapacity:4];
    _titleColors[@(CalendarCellStateNormal)]      = [UIColor darkTextColor];
    _titleColors[@(CalendarCellStateSelected)]    = [UIColor whiteColor];
    _titleColors[@(CalendarCellStateDisabled)]    = [UIColor grayColor];
    _titleColors[@(CalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
    _titleColors[@(CalendarCellStateToday)]       = [UIColor whiteColor];
    
    _subtitleColors = [NSMutableDictionary dictionaryWithCapacity:4];
    _subtitleColors[@(CalendarCellStateNormal)]      = [UIColor darkGrayColor];
    _subtitleColors[@(CalendarCellStateSelected)]    = [UIColor whiteColor];
    _subtitleColors[@(CalendarCellStateDisabled)]    = [UIColor lightGrayColor];
    _subtitleColors[@(CalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
    _subtitleColors[@(CalendarCellStateToday)]       = [UIColor whiteColor];
    
    _eventColor = [kBlue colorWithAlphaComponent:0.75];
    _cellStyle = CalendarCellStyleCircle;
    _autoAdjustTitleSize = YES;
    
    _topBorderLayer = [CALayer layer];
    _topBorderLayer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2].CGColor;
    [self.layer addSublayer:_topBorderLayer];
    _bottomBorderLayer = [CALayer layer];
    _bottomBorderLayer.backgroundColor = _topBorderLayer.backgroundColor;
    [self.layer addSublayer:_bottomBorderLayer];
    
    // 设置日历的起始日期
    _minimumDate = [NSDate _dateWithYear:1970 month:1 day:1];
    _maximumDate = [NSDate _dateWithYear:2099 month:12 day:31];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _supressEvent = YES;
    CGFloat padding = self._height * 0.01;
    _collectionView.frame = CGRectMake(0, kWeekHeight, self._width, self._height-kWeekHeight);
    _collectionViewFlowLayout.itemSize = CGSizeMake(
                                                    _collectionView._width/7-(_flow == CalendarFlowVertical)*0.1,
                                                    (_collectionView._height-padding*2)/6
                                                    );
    _collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(padding, 0, padding, 0);
    
    [_weekdays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat width = self._width/_weekdays.count;
        CGFloat height = kWeekHeight;
        [obj setFrame:CGRectMake(idx*width, 0, width, height)];
    }];
    [self adjustTitleIfNecessary];
    [self scrollToDate:_currentMonth];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    if (layer == self.layer) {
        _topBorderLayer.frame = CGRectMake(0, -1, self._width, 1);
        _bottomBorderLayer.frame = CGRectMake(0, self._height, self._width, 1);
    }
}

#pragma mark - UICollectionView dataSource/delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_maximumDate _monthsFrom:_minimumDate] + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleColors        = self.titleColors;
    cell.subtitleColors     = self.subtitleColors;
    cell.backgroundColors   = self.backgroundColors;
    cell.eventColor         = self.eventColor;
    cell.cellStyle          = self.cellStyle;
    cell.month              = [_minimumDate _dateByAddingMonths:indexPath.section];
    cell.currentDate        = self.currentDate;
    cell.titleLabel.font    = _titleFont;
    cell.subtitleLabel.font = _subtitleFont;
    cell.date               = [self dateForIndexPath:indexPath];
    cell.subtitle           = [self subtitleForDate:cell.date];
    cell.hasEvent           = [self hasEventForDate:cell.date];
    [cell configureCell];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isPlaceholder) {
        [self setSelectedDate:cell.date animate:YES];
    } else {
        [cell showAnimation];
        _selectedDate = [self dateForIndexPath:indexPath];
        [self didSelectDate:_selectedDate];
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    return [self shouldSelectDate:cell.date] && ![[collectionView indexPathsForSelectedItems] containsObject:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell hideAnimation];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollOffset = MAX(scrollView.contentOffset.x/scrollView._width,
                               scrollView.contentOffset.y/scrollView._height);
    NSDate *currentMonth = [_minimumDate _dateByAddingMonths:round(scrollOffset)];
    if (![_currentMonth _isEqualToDateForMonth:currentMonth]) {
        _currentMonth = [currentMonth copy];
        if (!_supressEvent) {
            [self currentMonthDidChange];
        }
    }
    if (_supressEvent) {
        _supressEvent = NO;
        return;
    }
    _header.scrollOffset = scrollOffset;
}

#pragma mark - Setter & Getter

- (void)setFlow:(CalendarFlow)flow
{
    if (self.flow != flow) {
        _flow = flow;
        NSIndexPath *newIndexPath;
        
        if (_collectionView.indexPathsForSelectedItems && _collectionView.indexPathsForSelectedItems.count) {
            NSIndexPath *indexPath = _collectionView.indexPathsForSelectedItems.lastObject;
            if (flow == CalendarFlowVertical) {
                NSInteger index  = indexPath.item;
                NSInteger row    = index % 6;
                NSInteger column = index / 6;
                newIndexPath = [NSIndexPath indexPathForRow:column+row*7
                                                  inSection:indexPath.section];
            } else if (flow == CalendarFlowHorizontal) {
                NSInteger index  = indexPath.item;
                NSInteger row    = index / 7;
                NSInteger column = index % 7;
                newIndexPath = [NSIndexPath indexPathForRow:row+column*6
                                                  inSection:indexPath.section];
            }
        }
        _collectionViewFlowLayout.scrollDirection = (UICollectionViewScrollDirection)flow;
        [self setNeedsLayout];
        [self reloadData:newIndexPath];
    }
}

- (CalendarFlow)flow
{
    return (CalendarFlow)_collectionViewFlowLayout.scrollDirection;
}

- (void)setFirstWeekday:(NSUInteger)firstWeekday
{
    if (_firstWeekday != firstWeekday) {
        _firstWeekday = firstWeekday;
        [[NSCalendar _sharedCalendar] setFirstWeekday:firstWeekday];
        [self reloadData];
    }
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    [self setSelectedDate:selectedDate animate:NO];
}

- (void)setSelectedDate:(NSDate *)selectedDate animate:(BOOL)animate
{
    NSIndexPath *selectedIndexPath = [self indexPathForDate:selectedDate];
    if (![_selectedDate _isEqualToDateForDay:selectedDate] && [self collectionView:_collectionView shouldSelectItemAtIndexPath:selectedIndexPath]) {
        NSIndexPath *currentIndex = [_collectionView indexPathsForSelectedItems].lastObject;
        [_collectionView deselectItemAtIndexPath:currentIndex animated:NO];
        [self collectionView:_collectionView didDeselectItemAtIndexPath:currentIndex];
        [_collectionView selectItemAtIndexPath:selectedIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:_collectionView didSelectItemAtIndexPath:selectedIndexPath];
    }
    if (!_collectionView.tracking && !_collectionView.decelerating && ![_currentMonth _isEqualToDateForMonth:_selectedDate]) {
        [self scrollToDate:selectedDate animate:animate];
    }
}


- (void)setCurrentDate:(NSDate *)currentDate
{
    if (![_currentDate _isEqualToDateForDay:currentDate]) {
      //  _currentDate = [currentDate copy];
      //  _currentMonth = [currentDate copy];
     //   dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollToDate:_currentDate];
      //  });
    }
}

//- (void)setCurrentMonth:(NSDate *)currentMonth
//{
//    if (![_currentMonth _isEqualToDateForMonth:currentMonth]) {
//        _currentMonth = [currentMonth copy];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self scrollToDate:_currentMonth];
//            [self currentMonthDidChange];
//        });
//    }
//}

- (void)setWeekdayFont:(UIFont *)weekdayFont
{
    if (_weekdayFont != weekdayFont) {
        _weekdayFont = weekdayFont;
        [_weekdays setValue:weekdayFont forKeyPath:@"font"];
    }
}

- (void)setWeekdayTextColor:(UIColor *)weekdayTextColor
{
    if (![_weekdayTextColor isEqual:weekdayTextColor]) {
        _weekdayTextColor = weekdayTextColor;
        [_weekdays setValue:weekdayTextColor forKeyPath:@"textColor"];
    }
}

- (void)setHeader:(CalendarHeader *)header
{
    if (_header != header) {
        _header = header;
        _topBorderLayer.hidden = header != nil;
    }
}

- (void)setHeaderTitleFont:(UIFont *)font
{
    if (_headerTitleFont != font) {
        _headerTitleFont = font;
        [_header reloadData];
    }
}

- (void)setHeaderTitleColor:(UIColor *)color
{
    if (![_headerTitleColor isEqual:color]) {
        _headerTitleColor = color;
        [_header reloadData];
    }
}

- (void)setHeaderDateFormat:(NSString *)dateFormat
{
    _header.dateFormat = dateFormat;
}

- (NSString *)headerDateFormat
{
    return _header.dateFormat;
}

- (void)setTitleDefaultColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(CalendarCellStateNormal)] = color;
    } else {
        [_titleColors removeObjectForKey:@(CalendarCellStateNormal)];
    }
    [self reloadData];
}

- (UIColor *)titleDefaultColor
{
    return _titleColors[@(CalendarCellStateNormal)];
}

- (void)setTitleSelectionColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(CalendarCellStateSelected)] = color;
    } else {
        [_titleColors removeObjectForKey:@(CalendarCellStateSelected)];
    }
    [self reloadData];
}

- (UIColor *)titleSelectionColor
{
    return _titleColors[@(CalendarCellStateSelected)];
}

- (void)setTitleTodayColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(CalendarCellStateToday)] = color;
    } else {
        [_titleColors removeObjectForKey:@(CalendarCellStateToday)];
    }
    [self reloadData];
}

- (UIColor *)titleTodayColor
{
    return _titleColors[@(CalendarCellStateToday)];
}

- (void)setTitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(CalendarCellStatePlaceholder)] = color;
    } else {
        [_titleColors removeObjectForKey:@(CalendarCellStatePlaceholder)];
    }
    [self reloadData];
}

- (UIColor *)titlePlaceholderColor
{
    return _titleColors[@(CalendarCellStatePlaceholder)];
}

- (void)setTitleWeekendColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(CalendarCellStateWeekend)] = color;
    } else {
        [_titleColors removeObjectForKey:@(CalendarCellStateWeekend)];
    }
    [self reloadData];
}

- (UIColor *)titleWeekendColor
{
    return _titleColors[@(CalendarCellStateWeekend)];
}

- (void)setSubtitleDefaultColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(CalendarCellStateNormal)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(CalendarCellStateNormal)];
    }
    [self reloadData];
}

-(UIColor *)subtitleDefaultColor
{
    return _subtitleColors[@(CalendarCellStateNormal)];
}

- (void)setSubtitleSelectionColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(CalendarCellStateSelected)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(CalendarCellStateSelected)];
    }
    [self reloadData];
}

- (UIColor *)subtitleSelectionColor
{
    return _subtitleColors[@(CalendarCellStateSelected)];
}

- (void)setSubtitleTodayColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(CalendarCellStateToday)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(CalendarCellStateToday)];
    }
    [self reloadData];
}

- (UIColor *)subtitleTodayColor
{
    return _subtitleColors[@(CalendarCellStateToday)];
}

- (void)setSubtitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(CalendarCellStatePlaceholder)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(CalendarCellStatePlaceholder)];
    }
    [self reloadData];
}

- (UIColor *)subtitlePlaceholderColor
{
    return _subtitleColors[@(CalendarCellStatePlaceholder)];
}

- (void)setSubtitleWeekendColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(CalendarCellStateWeekend)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(CalendarCellStateWeekend)];
    }
    [self reloadData];
}

- (UIColor *)subtitleWeekendColor
{
    return _subtitleColors[@(CalendarCellStateWeekend)];
}

- (void)setSelectionColor:(UIColor *)color
{
    if (color) {
        _backgroundColors[@(CalendarCellStateSelected)] = color;
    } else {
        [_backgroundColors removeObjectForKey:@(CalendarCellStateSelected)];
    }
    [self reloadData];
}

- (UIColor *)selectionColor
{
    return _backgroundColors[@(CalendarCellStateSelected)];
}

- (void)setTodayColor:(UIColor *)color
{
    if (color) {
        _backgroundColors[@(CalendarCellStateToday)] = color;
    } else {
        [_backgroundColors removeObjectForKey:@(CalendarCellStateToday)];
    }
    [self reloadData];
}

- (UIColor *)todayColor
{
    return _backgroundColors[@(CalendarCellStateToday)];
}

- (void)setEventColor:(UIColor *)eventColor
{
    if (![_eventColor isEqual:eventColor]) {
        _eventColor = eventColor;
        [self reloadData];
    }
}

- (void)setTitleFont:(UIFont *)font
{
    if (_titleFont != font) {
        _titleFont = font;
        if (_autoAdjustTitleSize) {
            return;
        }
        [self reloadData];
    }
}

- (void)setSubtitleFont:(UIFont *)font
{
    if (_subtitleFont != font) {
        _subtitleFont = font;
        if (_autoAdjustTitleSize) {
            return;
        }
        [self reloadData];
    }
}

- (void)setMinDissolvedAlpha:(CGFloat)minDissolvedAlpha
{
    if (_minDissolvedAlpha != minDissolvedAlpha) {
        _minDissolvedAlpha = minDissolvedAlpha;
        _header.minDissolveAlpha = minDissolvedAlpha;
    }
}

#pragma mark - Public

- (void)reloadData
{
    NSIndexPath *selectedPath = [_collectionView indexPathsForSelectedItems].lastObject;
    [self reloadData:selectedPath];
}

#pragma mark - Private

- (void)scrollToDate:(NSDate *)date
{
    [self scrollToDate:date animate:NO];
}

- (void)scrollToDate:(NSDate *)date animate:(BOOL)animate
{
    NSInteger scrollOffset = [date _monthsFrom:_minimumDate];
    _supressEvent = !animate;
    if (self.flow == CalendarFlowHorizontal) {
        [_collectionView setContentOffset:CGPointMake(scrollOffset * _collectionView._width, 0) animated:animate];
    } else if (self.flow == CalendarFlowVertical) {
        [_collectionView setContentOffset:CGPointMake(0, scrollOffset * _collectionView._height) animated:animate];
    }
    if (_header && !animate) {
        _header.scrollOffset = scrollOffset;
    }
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath
{
    NSDate *currentMonth = [_minimumDate _dateByAddingMonths:indexPath.section];
    NSDate *firstDayOfMonth = [NSDate _dateWithYear:currentMonth._year
                                                month:currentMonth._month
                                                  day:1];
    NSInteger numberOfPlaceholdersForPrev = ((firstDayOfMonth._weekday - _firstWeekday) + 7) % 7 ? : 7;
    NSDate *firstDateOfPage = [firstDayOfMonth _dateBySubtractingDays:numberOfPlaceholdersForPrev];
    NSDate *date;
    if (self.flow == CalendarFlowHorizontal) {
        NSUInteger    rows = indexPath.item % 6;
        NSUInteger columns = indexPath.item / 6;
        date = [firstDateOfPage _dateByAddingDays:7 * rows + columns];
    } else {
        date = [firstDateOfPage _dateByAddingDays:indexPath.item];
    }
    return date;
}

- (NSIndexPath *)indexPathForDate:(NSDate *)date
{
    NSInteger section = [date _monthsFrom:_minimumDate];
    NSDate *firstDayOfMonth = [NSDate _dateWithYear:date._year month:date._month day:1];
    NSInteger numberOfPlaceholdersForPrev = ((firstDayOfMonth._weekday - _firstWeekday) + 7) % 7 ? : 7;
    NSDate *firstDateOfPage = [firstDayOfMonth _dateBySubtractingDays:numberOfPlaceholdersForPrev];
    NSInteger item = 0;
    if (self.flow == CalendarFlowHorizontal) {
        NSInteger vItem = [date _daysFrom:firstDateOfPage];
        NSInteger rows = vItem/7;
        NSInteger columns = vItem%7;
        item = columns*6 + rows;
    } else if (self.flow == CalendarFlowVertical) {
        item = [date _daysFrom:firstDateOfPage];
    }
    return [NSIndexPath indexPathForItem:item inSection:section];
}

- (void)adjustTitleIfNecessary
{
    if (_autoAdjustTitleSize) {
        _titleFont       = [_titleFont fontWithSize:_collectionView._height/3/6];
        _subtitleFont    = [_subtitleFont fontWithSize:_collectionView._height/4.5/6];
        _headerTitleFont = [_headerTitleFont fontWithSize:_titleFont.pointSize+3];
        _weekdayFont     = _titleFont;
        [self reloadData];
    }
}

- (BOOL)shouldSelectDate:(NSDate *)date
{
    if (_delegate && [_delegate respondsToSelector:@selector(calendar:shouldSelectDate:)]) {
        return [_delegate calendar:self shouldSelectDate:date];
    }
    return YES;
}

- (void)didSelectDate:(NSDate *)date
{
    if (_delegate && [_delegate respondsToSelector:@selector(calendar:didSelectDate:)]) {
        [_delegate calendar:self didSelectDate:date];
    }
}

- (void)currentMonthDidChange
{
    if (_delegate && [_delegate respondsToSelector:@selector(calendarCurrentMonthDidChange:)]) {
        [_delegate calendarCurrentMonthDidChange:self];
    }
}

- (NSString *)subtitleForDate:(NSDate *)date
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(calendar:subtitleForDate:)]) {
        return [_dataSource calendar:self subtitleForDate:date];
    }
    return nil;
}

// 某一天是否有事件
- (BOOL)hasEventForDate:(NSDate *)date
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(calendar:hasEventForDate:)]) {
        return [_dataSource calendar:self hasEventForDate:date];
    }
    return NO;
}

- (void)setAutoAdjustTitleSize:(BOOL)autoAdjustTitleSize
{
    if (_autoAdjustTitleSize != autoAdjustTitleSize) {
        _autoAdjustTitleSize = autoAdjustTitleSize;
        [self reloadData];
    }
}

- (void)setCellStyle:(CalendarCellStyle)cellStyle
{
    if (_cellStyle != cellStyle) {
        _cellStyle = cellStyle;
        [self reloadData];
    }
}

- (void)reloadData:(NSIndexPath *)selection
{
    [_collectionView reloadData];
    [_collectionView selectItemAtIndexPath:selection animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    [_weekdays setValue:_weekdayFont forKey:@"font"];
    
    _header.titleFont       = self.headerTitleFont;
    _header.titleColor      = self.headerTitleColor;
    _header.scrollDirection = self.collectionViewFlowLayout.scrollDirection;
    [_header reloadData];
    
    [_weekdays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *weekdayLabel = obj;
        NSUInteger absoluteIndex = ((idx-(_firstWeekday-1))+7)%7;
        weekdayLabel.frame = CGRectMake(absoluteIndex*weekdayLabel._width,
                                        0,
                                        weekdayLabel._width,
                                        weekdayLabel._height);
    }];
}



@end

