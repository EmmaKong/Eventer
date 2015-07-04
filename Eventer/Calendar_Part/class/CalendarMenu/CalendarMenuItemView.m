//
//  CalendarMenuItemView.m
//  Calendar
//
//  Created by emma on 15/4/24.
//  Copyright (c) 2015年 Emma. All rights reserved.
//

#import "CalendarMenuItemView.h"

@interface CalendarMenuItemView ()

@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation CalendarMenuItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/ //frame  menu  item
- (id)initWithFrame:(CGRect)frame menu:(CalendarMenu *)menu item:(CalendarMenuItem*) item 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menu = menu;
        self.item = item;
        self.isAccessibilityElement = YES;
        self.accessibilityTraits = UIAccessibilityTraitButton;
        self.accessibilityHint = NSLocalizedString(@"Double tap to choose", @"Double tap to choose");
        
        _backgroundView = ({
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            view;
        });
        [self addSubview:_backgroundView];
        
        CGRect titleFrame;
        
        //菜单 title位置与大小
        titleFrame = CGRectMake(self.item.textOffset.width == 0.0 && self.item.textOffset.height == 0.0 ? self.menu.textOffset.width : self.item.textOffset.width, self.item.textOffset.width == 0.0 && self.item.textOffset.height == 0.0 ? self.menu.textOffset.height : self.item.textOffset.height, 80, frame.size.height);
       
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:titleFrame];
            label.isAccessibilityElement = NO;
            label.contentMode = UIViewContentModeCenter;
            label.textAlignment = self.menu.textAlignment;
            label.backgroundColor = [UIColor clearColor];
            label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            label;
        });
        
        [self addSubview:_titleLabel];
            }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Accessibility
    self.accessibilityLabel = self.item.title;
    
    // Adjust styles
    self.backgroundView.backgroundColor = self.item.backgroundColor == nil ? [UIColor clearColor] : self.item.backgroundColor;
    self.titleLabel.font = self.item.font == nil ? self.menu.font : self.item.font;
    self.titleLabel.text = self.item.title;
    self.titleLabel.textColor = self.item.textColor == nil ? self.menu.textColor : self.item.textColor;
    self.titleLabel.shadowColor = self.item.textShadowColor ? self.menu.textShadowColor : self.item.textShadowColor;
    self.titleLabel.shadowOffset = self.item.textShadowOffset.width == 0 && self.item.textShadowOffset.height == 0 ? self.menu.textShadowOffset : self.item.textShadowOffset;
    self.titleLabel.textAlignment = (NSInteger)self.item.textAlignment == -1 ? self.menu.textAlignment : self.item.textAlignment;
 
    //self.item.customView.frame = CGRectMake(0, 0, self.titleLabel.frame.size.width, self.frame.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.backgroundColor = self.item.highlightedBackgroundColor == nil ? self.menu.highlightedBackgroundColor : self.item.highlightedBackgroundColor;
    self.separatorView.backgroundColor = self.item.highlightedSeparatorColor == nil ? self.menu.highlightedSeparatorColor : self.item.highlightedSeparatorColor;
   
    self.titleLabel.textColor = self.item.highlightedTextColor == nil ? self.menu.highlightedTextColor : self.item.highlightedTextColor;
    self.titleLabel.shadowColor = self.item.highlightedTextShadowColor == nil ? self.menu.highlightedTextShadowColor : self.item.highlightedTextShadowColor;
    self.titleLabel.shadowOffset = self.item.highlightedTextShadowOffset.width == 0 && self.item.highlightedTextShadowOffset.height == 0 ? self.menu.highlightedTextShadowOffset : self.item.highlightedTextShadowOffset;
  
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.backgroundColor = self.item.backgroundColor == nil ? [UIColor clearColor] : self.item.backgroundColor;
    self.separatorView.backgroundColor = self.menu.separatorColor;
   
    self.titleLabel.textColor = self.item.textColor == nil ? self.menu.textColor : self.item.textColor;
    self.titleLabel.shadowColor = self.item.textShadowColor == nil ?self.menu.textShadowColor : self.item.textShadowColor;
    self.titleLabel.shadowOffset = self.item.textShadowOffset.width == 0  && self.item.textShadowOffset.height == 0 ? self.menu.textShadowOffset : self.item.textShadowOffset;
 
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.backgroundColor = self.item.backgroundColor == nil ? [UIColor clearColor] : self.item.backgroundColor;
    self.separatorView.backgroundColor = self.item.separatorColor == nil ? self.menu.separatorColor : self.item.separatorColor;

    self.titleLabel.textColor = self.item.textColor == nil ? self.menu.textColor : self.item.textColor;
    self.titleLabel.shadowColor = self.item.textShadowColor == nil ? self.menu.textShadowColor : self.item.textShadowColor;
    self.titleLabel.shadowOffset = self.item.textShadowOffset.width == 0 && self.item.textShadowOffset.height ? self.menu.textShadowOffset : self.item.textShadowOffset;
  
    
    CGPoint endedPoint = [touches.anyObject locationInView:self];
    if (endedPoint.y < 0 || endedPoint.y > CGRectGetHeight(self.bounds))
        return;
    
    if (!self.menu.closeOnSelection) {
        if (self.item.action)
            self.item.action(self.item);
    } else {
        if (self.item.action) {
            if (self.menu.waitUntilAnimationIsComplete) {
                __typeof (&*self) __weak weakSelf = self;
                [self.menu closeWithCompletion:^{
                    weakSelf.item.action(weakSelf.item);
                }];
            } else {
                [self.menu close];
                self.item.action(self.item);
            }
        }
    }
}

@end
