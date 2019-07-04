//
//  NSString+YD_Extension.m
//  YD_BasicProject
//
//  Created by 杨达 on 2019/6/1.
//  Copyright © 2019 guests. All rights reserved.
//

#import "NSString+YD_Extension.h"

@implementation NSString (YD_Extension)

- (NSString *)stringWithUTF8Encoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)timeToString:(NSTimeInterval)duration format:(NSString *)format {
    NSInteger time = roundf(duration);
    NSInteger min = roundf(time / 60);
    NSInteger sec = time - (min * 60);
    return [NSString stringWithFormat:format, min, sec];
}

@end
