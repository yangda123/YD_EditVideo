//
//  YD_BaseView.m
//  YD_BasicProject
//
//  Created by 杨达 on 2019/5/1.
//  Copyright © 2019 guests. All rights reserved.
//

#import "YD_BaseView.h"

@implementation YD_BaseView

- (void)dealloc {
    NSLog(@"=== %s dealloc ===", object_getClassName(self));
}

/// 初始化UI
- (void)yd_layoutSubViews {}
/// 布局UI
- (void)yd_layoutConstraints {}

@end
