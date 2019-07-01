//
//  YD_CGAffineManager.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YD_Orientation) {
    YD_OrientationUp    = 0,
    YD_OrientationRight = 90,
    YD_OrientationDown  = 180,
    YD_OrientationLeft  = 270
};

NS_ASSUME_NONNULL_BEGIN

@interface YD_CGAffineManager : NSObject

+ (NSUInteger)yd_orientation:(CGAffineTransform)transform;

@end

NS_ASSUME_NONNULL_END
