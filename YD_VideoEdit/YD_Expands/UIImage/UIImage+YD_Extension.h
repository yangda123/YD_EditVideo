//
//  UIImage+YD_Extension.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YD_Extension)
// 获取bundle的图片
+ (UIImage *)yd_imageWithName:(NSString *)imgName;
// 修改图片的颜色
- (UIImage *)imageChangeColor:(UIColor *)color;
// 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;
// 根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
// 从中间拉伸图片
+ (UIImage *)resizeImage:(NSString *)imgName;
// 防止渲染，显示原始图片
+ (UIImage *)imageWithOriginalName:(NSString *)imageName;
// 压缩图片到指定大小
+ (UIImage *)scaleImageWith:(UIImage *)image targetWidth:(CGFloat)width;
/// 滤镜图片
- (UIImage *)filterName:(NSString *)filterName;

@end

NS_ASSUME_NONNULL_END
