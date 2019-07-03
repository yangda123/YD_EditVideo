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

+ (UIImage *)yd_imageWithName:(NSString *)imgName;

- (UIImage *)imageChangeColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
