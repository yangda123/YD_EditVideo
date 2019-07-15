//
//  YD_ClipViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_ClipViewController.h"
#import "YD_ClipView.h"

@interface YD_ClipViewController ()

@property (nonatomic, weak) YD_ClipView *clipView;
@property (nonatomic, assign) CGFloat selectRatio;

@end

@implementation YD_ClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)yd_setupConfig {
    [super yd_setupConfig];
    
    CGSize size = [self.model.asset yd_naturalSize];
    self.selectRatio = size.height == 0 ? 1.0 : size.width / size.height;
}

- (void)yd_layoutSubViews {
    [super yd_layoutSubViews];
    
    {
        YD_ClipView *clipView = [[YD_ClipView alloc] initWithAsset:self.model.asset];
        self.clipView = clipView;
        [self.view addSubview:clipView];
    }
}

- (void)yd_layoutConstraints {
    [super yd_layoutConstraints];
    
    [self.clipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.player.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"裁剪";
}

- (UIImage *)yd_barIconImage {
    
    return self.model.barIconImage ?: [UIImage yd_imageWithName:@"yd_aspectRatio@3x"];
}

- (void)yd_completeItemAction {
    
    [self.player yd_pause];
    
   
}

@end
