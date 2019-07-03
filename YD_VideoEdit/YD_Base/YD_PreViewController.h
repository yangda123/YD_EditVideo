//
//  YD_PreViewController.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/2.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseViewController.h"
#import "YD_ConfigModel.h"

typedef void(^YD_SaveBlock)(UIViewController *_Nonnull controller, NSString *_Nonnull urlPaht);
typedef void(^YD_ShareBlock)(UIViewController *_Nonnull controller, NSString *_Nonnull urlPaht);

NS_ASSUME_NONNULL_BEGIN

@interface YD_PreViewController : YD_BaseViewController
/// 主体的颜色
@property (nonatomic, strong) UIColor *themeColor;
/// 保存和分享字体的颜色
@property (nonatomic, strong) UIColor *btnTitleColor;
/// 视频播放URL
@property (nonatomic, copy  ) NSString *urlPath;
/// 返回首页图标
@property (nonatomic, strong) UIImage *backHomeImage;

#pragma mark - 分享和保存的回掉
@property (nonatomic, copy) YD_SaveBlock  saveBlock;
@property (nonatomic, copy) YD_ShareBlock shareBlock;

@end

NS_ASSUME_NONNULL_END
