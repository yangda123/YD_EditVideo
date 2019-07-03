//
//  YD_BottomBar.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

#define YD_BottomBarH (YD_BottomBangsH + 49)

NS_ASSUME_NONNULL_BEGIN

@interface YD_BottomBar : YD_BaseView

+ (instancetype)addBar:(NSString *)title image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
