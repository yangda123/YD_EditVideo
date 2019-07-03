//
//  UIImage+YD_Extension.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "UIImage+YD_Extension.h"
#import "YD_BaseViewController.h"

@implementation UIImage (YD_Extension)

// 绘图
- (UIImage *)imageChangeColor:(UIColor *)color {
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)yd_imageWithName:(NSString *)imgName {
    NSBundle *mainBundle = [NSBundle bundleForClass:[YD_BaseViewController class]];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"YD_Images" ofType:@"bundle"]];
    NSString *imgPath = [resourcesBundle pathForResource:imgName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
    return image;
}

@end
