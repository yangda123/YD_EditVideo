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

+ (UIImage *)yd_imageWithName:(NSString *)imgName {
    NSBundle *mainBundle = [NSBundle bundleForClass:[YD_BaseViewController class]];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"YD_Images" ofType:@"bundle"]];
    NSString *imgPath = [resourcesBundle pathForResource:imgName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
    return image;
}

@end
