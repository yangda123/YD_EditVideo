//
//  YD_BaseView.h
//  YD_BasicProject
//
//  Created by 杨达 on 2019/5/1.
//  Copyright © 2019 guests. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YD_VideoEditManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_BaseView : UIView

/// 初始化UI
- (void)yd_layoutSubViews;
/// 布局UI
- (void)yd_layoutConstraints;

@end

NS_ASSUME_NONNULL_END
