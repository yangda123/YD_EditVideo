//
//  UIView+YDExtension.m
//  YDScrollerView
//
//  Created by sqj on 17/1/10.
//  Copyright © 2017年 zsmy. All rights reserved.
//

#import "UIView+YDExtension.h"

@implementation UIView (YDExtension)

- (void)setYD_x:(CGFloat)YD_x
{
    CGRect frame = self.frame;
    frame.origin.x = YD_x;
    self.frame = frame;
}

- (void)setYD_y:(CGFloat)YD_y
{
    CGRect frame = self.frame;
    frame.origin.y = YD_y;
    self.frame = frame;
}

- (void)setYD_width:(CGFloat)YD_width
{
    CGRect frame = self.frame;
    frame.size.width = YD_width;
    self.frame = frame;
}

- (void)setYD_height:(CGFloat)YD_height
{
    CGRect frame = self.frame;
    frame.size.height = YD_height;
    self.frame = frame;
}

- (CGFloat)YD_x
{
    return self.frame.origin.x;
}

- (CGFloat)YD_y
{
    return self.frame.origin.y;
}

- (CGFloat)YD_width
{
    return self.frame.size.width;
}

- (CGFloat)YD_height
{
    return self.frame.size.height;
}

- (CGFloat)YD_centerX
{
    return self.center.x;
}

- (void)setYD_centerX:(CGFloat)YD_centerX
{
    CGPoint center = self.center;
    center.x = YD_centerX;
    self.center = center;
}

- (CGFloat)YD_centerY
{
    return self.center.y;
}

- (void)setYD_centerY:(CGFloat)YD_centerY
{
    CGPoint center = self.center;
    center.y = YD_centerY;
    self.center = center;
}

- (void)setYD_size:(CGSize)YD_size
{
    CGRect frame = self.frame;
    frame.size = YD_size;
    self.frame = frame;
}

- (CGSize)YD_size
{
    return self.frame.size;
}

- (CGFloat)YD_right
{
    //    return self.YD_x + self.YD_width;
    return CGRectGetMaxX(self.frame);
}

- (void)setYD_right:(CGFloat)YD_right
{
    self.YD_x = YD_right - self.YD_width;
}

- (CGFloat)YD_bottom
{
    //    return self.YD_y + self.YD_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setYD_bottom:(CGFloat)YD_bottom
{
    self.YD_y = YD_bottom - self.YD_height;
}

@end





















































