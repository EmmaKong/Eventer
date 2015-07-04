//
//  UIView+Extension.m
//  Calendar
//
//  Created by emma on 15/6/13.
//  Copyright (c) 2015年 Emma. All rights reserved.
//


#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGFloat)_width
{
    return CGRectGetWidth(self.frame);
}

- (void)set_width:(CGFloat)_width
{
    self.frame = CGRectMake(self._left, self._top, _width, self._height);
}

- (CGFloat)_height
{
    return CGRectGetHeight(self.frame);
}

- (void)set_height:(CGFloat)_height
{
    self.frame = CGRectMake(self._left, self._top, self._width, _height);
}

- (CGFloat)_top
{
    return CGRectGetMinY(self.frame);
}

- (void)set_top:(CGFloat)_top
{
    self.frame = CGRectMake(self._left, _top, self._width, self._height);
}

- (CGFloat)_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)set_bottom:(CGFloat)_bottom
{
    self._top = _bottom - self._height;
}

- (CGFloat)_left
{
    return CGRectGetMinX(self.frame);
}

- (void)set_left:(CGFloat)_left
{
    self.frame = CGRectMake(_left, self._top, self._width, self._height);
}

- (CGFloat)_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)set_right:(CGFloat)_right
{
    self._left = self._right - self._width;
}

@end
