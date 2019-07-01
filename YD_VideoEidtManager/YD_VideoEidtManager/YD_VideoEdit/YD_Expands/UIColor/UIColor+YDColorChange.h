//
//  UIColor+YDColorChange.h
//  掌尚User
//
//  Created by SQJ on 2017/5/11.
//  Copyright © 2017年 SQJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YDColorChange)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *)colorWithHexString:(NSString *)color;

//绘制渐变色
+ (void)setGradualChangingColor:(UIView *)view bgView:(UIView *)bgView fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;

@end
