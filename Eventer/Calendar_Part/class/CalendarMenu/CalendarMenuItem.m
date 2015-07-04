//
//  CalendarMenuItem.m
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CalendarMenuItem.h"

@interface CalendarMenuItem ()
@property (assign, nonatomic) CalendarMenuItemView *itemView;
@end


@implementation CalendarMenuItem
- (id)initWithTitle:(NSString *)title action:(void (^)(CalendarMenuItem *item))action
{
    self = [super init];
    if (self) {
        _title = title;
        _action = action;
        _textAlignment = -1;
    }
    return self;
}


- (id)initWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor action:(void (^)(CalendarMenuItem *item))action
{
    self = [super init];
    if (self) {
        _title = title;
        _action = action;
        _textAlignment = -1;
    }
    return self;
}


- (id)initWithCustomView:(UIView *)customView action:(void (^)(CalendarMenuItem *item))action
{
    self = [super init];
    if (self) {
        _customView = customView;
        _action = action;
    }
    return self;
}

- (id)initWithCustomView:(UIView *)customView
{
    self = [super init];
    if (self) {
        _customView = customView;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<title: %@; tag: %li>", self.title, (long)self.tag];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.itemView.titleLabel.text = title;
    self.itemView.accessibilityLabel = title;
}


/*- (void)setImage:(UIImage *)image
{
    _image = image;
    self.itemView.imageView.image = image;
}

- (void)setImageBackgroundColor:(UIColor *)imageBackgroundColor
{
    _imageBackgroundColor = imageBackgroundColor;
    self.itemView.imageView.backgroundColor = imageBackgroundColor;
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    _highlightedImage = highlightedImage;
    self.itemView.imageView.highlightedImage = highlightedImage;
}
*/
- (void)setNeedsLayout
{
    [self.itemView layoutSubviews];
}

@end
