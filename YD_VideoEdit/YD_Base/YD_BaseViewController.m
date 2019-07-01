//
//  YD_BaseViewController.m
//  YD_BasicProject
//
//  Created by 杨达 on 2019/5/1.
//  Copyright © 2019 guests. All rights reserved.
//

#import "YD_BaseViewController.h"

@interface YD_BaseViewController ()

@end

@implementation YD_BaseViewController

- (void)dealloc {
    NSLog(@"--- %s dealloc ---", object_getClassName(self));
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    /// 初始化数据
    [self yd_setupConfig];
    /// 初始化UI
    [self yd_layoutSubViews];
    /// 布局UI
    [self yd_layoutConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 基础方法 - 子类需要重新实现
/// 初始化数据
- (void)yd_setupConfig {}
/// 初始化UI
- (void)yd_layoutSubViews {}
/// 布局UI
- (void)yd_layoutConstraints {}

@end
