//
//  NSString+YD_Extension.h
//  YD_BasicProject
//
//  Created by 杨达 on 2019/6/1.
//  Copyright © 2019 guests. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YD_Extension)

- (NSString *)stringWithUTF8Encoding;

+ (NSString *)timeToString:(NSTimeInterval)duration
                    format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
