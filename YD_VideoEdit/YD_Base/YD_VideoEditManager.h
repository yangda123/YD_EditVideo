
//
//  YD_VideoEditManager.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

/** 导航栏的高度 */
#define YD_NavigationBarH 44.0
/** 状态栏的高度 */
#define YD_StatusBarH [UIApplication sharedApplication].statusBarFrame.size.height
/** 导航栏和状态栏的高度 */
#define YD_TopBarHeight (YD_NavigationBarH + YD_StatusBarH)
/** 屏幕的尺寸 */
#define YD_ScreenSize   [UIScreen mainScreen].bounds.size
/** 屏幕的高 */
#define YD_ScreenHeight [UIScreen mainScreen].bounds.size.height
/** 屏幕的宽 */
#define YD_ScreenWidth  [UIScreen mainScreen].bounds.size.width
/** 计算比例后的宽度 */
#define YD_IPhone7_Width(w)  (w*(YD_ScreenWidth/375.0f))
/** 计算比例后高度 */
#define YD_IPhone7_Height(h) (h*(YD_ScreenHeight/677.0f))
/** 判断是否是iphone_x */
#define YD_Is_IPHONEX ([[UIScreen mainScreen] bounds].size.height > 736.0f)
/** 底部刘海的高度 */
#define YD_BottomBangsH (YD_Is_IPHONEX ? 34 : 0)
/** 沙盒 */
#define YD_PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]
#define YD_PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

/** 获取RGB颜色 */
#define RGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)     RGBA(r,g,b,1.0f)


#import "YD_ProgressHUD.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import "YD_CGAffineManager.h"
#import "YD_AssetManager.h"

#import "UIView+YDExtension.h"
#import "UIColor+YDColorChange.h"
#import "UIButton+YD_Extension.h"
#import "AVAsset+YD_Extension.h"
#import "UIImage+YD_Extension.h"
#import "NSString+YD_Extension.h"
