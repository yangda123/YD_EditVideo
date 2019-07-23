//
//  YD_BaseViewController.h
//  YD_BasicProject
//
//  Created by 杨达 on 2019/5/1.
//  Copyright © 2019 guests. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YD_VideoEditManager.h"
#import "YD_BottomBar.h"

#import "UINavigationController+FDFullscreenPopGesture.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_BaseViewController : UIViewController

#pragma mark - 基础方法 - 子类需要重新实现
/// 初始化数据 - 基础数据，导航栏等配置
- (void)yd_setupConfig;
/// 初始化UI
- (void)yd_layoutSubViews;
/// 布局UI
- (void)yd_layoutConstraints;

@end

NS_ASSUME_NONNULL_END
