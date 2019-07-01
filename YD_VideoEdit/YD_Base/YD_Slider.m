//
//  YD_Slider.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_Slider.h"

@implementation YD_Slider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - self.left_offset;
    rect.size.width = rect.size.width + (self.left_offset + self.right_offset);
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 3, 0);
}

@end
