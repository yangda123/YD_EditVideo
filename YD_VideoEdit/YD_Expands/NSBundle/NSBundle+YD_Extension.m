//
//  NSBundle+YD_Extension.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/2.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSBundle+YD_Extension.h"
#import "YD_BaseViewController.h"

@implementation NSBundle (YD_Extension)

+ (NSString *)yd_imageFilePath:(NSString *)imgName {
    NSBundle *mainBundle = [NSBundle bundleForClass:[YD_BaseViewController class]];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"YD_Images" ofType:@"bundle"]];
    NSString *imgPath = [resourcesBundle pathForResource:imgName ofType:@"png"];
    return imgPath;
}

@end
