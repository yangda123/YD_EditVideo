//
//  UIColor+YDColorChange.m
//  掌尚User
//
//  Created by SQJ on 2017/5/11.
//  Copyright © 2017年 SQJ. All rights reserved.
//

#import "UIColor+YDColorChange.h"

@implementation UIColor (YDColorChange)

+ (UIColor *)hexStringColor:(NSString *)strColor{
    
    unsigned int red,green,blue;
    
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[strColor substringWithRange:range]]scanHexInt:&red];
    
    range.length = 2;
    range.location = 2;
    [[NSScanner scannerWithString:[strColor substringWithRange:range]]scanHexInt:&green];
    
    range.length = 2;
    range.location = 4;
    [[NSScanner scannerWithString:[strColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//绘制渐变色
+ (void)setGradualChangingColor:(UIView *)view bgView:(UIView *)bgView fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr {
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.frame;
    
    //  创建渐变色数组，需要转换为CGColor颜色 （因为这个按钮有三段变色，所以有三个元素）
    gradientLayer.colors = @[(__bridge id)[self colorWithHexString:fromHexColorStr].CGColor,(__bridge id)[self colorWithHexString:toHexColorStr].CGColor];
    
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    //    gradientLayer.mask = view.layer;
    [bgView.layer addSublayer:gradientLayer];
    gradientLayer.mask = view.layer;
    
    view.frame = gradientLayer.bounds;
    
    //  设置颜色变化点，取值范围 0.0~1.0 （所以变化点有三个）
    //    gradientLayer.locations = @[@0,@0.5,@1];
    
}


+(void)TextGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = view.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = view.layer;
    view.frame = gradientLayer1.bounds;
}

@end
























