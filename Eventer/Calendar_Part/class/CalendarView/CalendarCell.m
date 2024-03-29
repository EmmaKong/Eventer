//
//  CalendarCell.m
//  Calendar
//
//  Created by emma on 15/6/13.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CalendarCell.h"
#import "Calendar.h"
#import "UIView+Extension.h"
#import "NSDate+Extension.h"

#define kAnimationDuration 0.15

@interface CalendarCell ()

@property (strong,   nonatomic) CAShapeLayer *backgroundLayer;
@property (strong,   nonatomic) CAShapeLayer *eventLayer;
@property (readonly, nonatomic) BOOL         today;
@property (readonly, nonatomic) BOOL         weekend;


- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary;

@end

@implementation CalendarCell

#pragma mark - Init and life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.font = [UIFont systemFontOfSize:10];
        subtitleLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
        
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
        _backgroundLayer.hidden = YES;
        [self.contentView.layer insertSublayer:_backgroundLayer atIndex:0];
        
        _eventLayer = [CAShapeLayer layer];
        _eventLayer.backgroundColor = [UIColor clearColor].CGColor;
        _eventLayer.fillColor = [UIColor cyanColor].CGColor;
        _eventLayer.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer.bounds].CGPath;
        _eventLayer.hidden = YES;
        [self.contentView.layer addSublayer:_eventLayer];
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    CGFloat titleHeight = self.bounds.size.height*5.0/6.0;
    CGFloat diameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);
    _backgroundLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
                                        (titleHeight-diameter)/2,
                                        diameter,
                                        diameter);
    
    CGFloat eventSize = _backgroundLayer.frame.size.height/6.0;
    _eventLayer.frame = CGRectMake((_backgroundLayer.frame.size.width-eventSize)/2+_backgroundLayer.frame.origin.x, CGRectGetMaxY(_backgroundLayer.frame)+eventSize*0.2, eventSize*0.8, eventSize*0.8);
    _eventLayer.path = [UIBezierPath bezierPathWithOvalInRect:_eventLayer.bounds].CGPath;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [CATransaction setDisableActions:YES];
}

#pragma mark - Public

- (void)showAnimation
{
    _backgroundLayer.hidden = NO;
    _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
    _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = @0.3;
    zoomOut.toValue = @1.2;
    zoomOut.duration = kAnimationDuration/4*3;
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.fromValue = @1.2;
    zoomIn.toValue = @1.0;
    zoomIn.beginTime = kAnimationDuration/4*3;
    zoomIn.duration = kAnimationDuration/4;
    group.duration = kAnimationDuration;
    group.animations = @[zoomOut, zoomIn];
    [_backgroundLayer addAnimation:group forKey:@"bounce"];
    [self configureCell];
}

- (void)hideAnimation
{
    _backgroundLayer.hidden = YES;
    [self configureCell];
}

#pragma mark - Private

- (void)configureCell
{
    _titleLabel.text = [NSString stringWithFormat:@"%@",@(_date._day)];
    _subtitleLabel.text = _subtitle;
    _titleLabel.textColor = [self colorForCurrentStateInDictionary:_titleColors];
    _subtitleLabel.textColor = [self colorForCurrentStateInDictionary:_subtitleColors];
    _backgroundLayer.fillColor = [self colorForCurrentStateInDictionary:_backgroundColors].CGColor;
    
    CGFloat titleHeight = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
    if (_subtitleLabel.text) {
        _subtitleLabel.hidden = NO;
        CGFloat subtitleHeight = [_subtitleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.subtitleLabel.font}].height;
        CGFloat height = titleHeight + subtitleHeight;
        _titleLabel.frame = CGRectMake(0,
                                       (self.contentView._height*5.0/6.0-height)*0.5,
                                       self._width,
                                       titleHeight);
        
        _subtitleLabel.frame = CGRectMake(0,
                                          _titleLabel._bottom - (_titleLabel._height-_titleLabel.font.pointSize),
                                          self._width,
                                          subtitleHeight);
    } else {
        _titleLabel.frame = CGRectMake(0, 0, self._width, floor(self.contentView._height*5.0/6.0));
        _subtitleLabel.hidden = YES;
    }
    _backgroundLayer.hidden = !self.selected && !self.isToday;
    _backgroundLayer.path = _cellStyle == CalendarCellStyleCircle ?
    [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath :
    [UIBezierPath bezierPathWithRect:_backgroundLayer.bounds].CGPath;
    _eventLayer.fillColor = _eventColor.CGColor;
    _eventLayer.hidden = !_hasEvent;
}

- (BOOL)isPlaceholder
{
    return ![_date _isEqualToDateForMonth:_month];
}

- (BOOL)isToday
{
    return [_date _isEqualToDateForDay:_currentDate];
}

- (BOOL)isWeekend
{
    return self.date._weekday == 1 || self.date._weekday == 7;
}

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary
{
    if (self.isSelected) {
        return dictionary[@(CalendarCellStateSelected)];
    }
    if (self.isToday) {
        return dictionary[@(CalendarCellStateToday)];
    }
    if (self.isPlaceholder) {
        return dictionary[@(CalendarCellStatePlaceholder)];
    }
    if (self.isWeekend && [[dictionary allKeys] containsObject:@(CalendarCellStateWeekend)]) {
        return dictionary[@(CalendarCellStateWeekend)];
    }
    return dictionary[@(CalendarCellStateNormal)];
}

@end
