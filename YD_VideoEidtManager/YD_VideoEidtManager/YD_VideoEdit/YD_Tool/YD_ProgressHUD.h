//
//  YD_ProgressHUD.h
//  YD_MarketVideo
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef void(^YD_TodayBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface YD_ProgressHUD : NSObject

+ (MBProgressHUD *)yd_showMessage:(NSString *)message;
+ (MBProgressHUD *)yd_showMessage:(NSString *)message toView:(UIView *)view;

+ (void)yd_hideHUD;
+ (void)yd_hideHUDToView:(UIView *)view;
+ (MBProgressHUD *)yd_showHUD:(NSString *)message;
+ (MBProgressHUD *)yd_showHUD:(NSString *)message toView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
