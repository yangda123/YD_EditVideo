//
//  YD_ProgressHUD.m
//  YD_MarketVideo
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_ProgressHUD.h"
#import "UIView+YDExtension.h"

@implementation YD_ProgressHUD

+ (void)yd_hideHUD {
    [MBProgressHUD hideHUDForView:UIApplication.sharedApplication.keyWindow animated:NO];
}

+ (void)yd_hideHUDToView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:NO];
}

+ (MBProgressHUD *)yd_showHUD:(NSString *)message {
    return [self yd_showHUD:message toView:UIApplication.sharedApplication.keyWindow];
}

+ (MBProgressHUD *)yd_showHUD:(NSString *)message toView:(UIView *)view {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.userInteractionEnabled = YES;
    hud.contentColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:10];
    hud.margin = 15.0;
    hud.offset = CGPointMake(hud.bezelView.YD_x, hud.bezelView.YD_y - 60);
    hud.minSize = CGSizeMake(90, 90);
    hud.label.text = message;
    return hud;
}

+ (MBProgressHUD *)yd_showMessage:(NSString *)message {
    
    UIView *view = UIApplication.sharedApplication.keyWindow;
    
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.offset = CGPointMake(hud.bezelView.YD_x, hud.bezelView.YD_y - 60);
    [hud hideAnimated:YES afterDelay:2.0f];
    
    return hud;
}

+ (MBProgressHUD *)yd_showMessage:(NSString *)message toView:(UIView *)view {
    
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.offset = CGPointMake(hud.bezelView.YD_x, hud.bezelView.YD_y - 60);
    [hud hideAnimated:YES afterDelay:2.0f];
    
    return hud;
}

@end
