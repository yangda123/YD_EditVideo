//
//  YD_AspectRatioViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_AspectRatioViewController.h"
#import "YD_RatioView.h"
#import "YD_AssetManager.h"

@interface YD_AspectRatioViewController ()

@property (nonatomic, weak) YD_RatioView *ratioView;
@property (nonatomic, assign) CGFloat selectRatio;

@end

@implementation YD_AspectRatioViewController

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
        YD_RatioView *ratioView = [[YD_RatioView alloc] initWithRatio:self.selectRatio];
        self.ratioView = ratioView;
        ratioView.themeColor = self.model.themeColor;
        [self.view addSubview:ratioView];
        
        @weakify(self);
        ratioView.ratioBlock = ^(CGFloat ratio) {
            @strongify(self) ;
            self.selectRatio = ratio;
            [self yd_updatePlayerFrame];
        };
    }
}

- (void)yd_layoutConstraints {
    [super yd_layoutConstraints];
    
    [self.ratioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.player.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
}

- (void)yd_updatePlayerFrame {
    CGFloat ratio = self.selectRatio;
    self.player.containView.backgroundColor = UIColor.blackColor;
    
    if (ratio >= 1.0) {
        CGFloat width = YD_ScreenWidth;
        CGFloat height = width / ratio;
        self.player.containView.frame = CGRectMake(0, YD_ScreenWidth * 0.5 - height * 0.5, width, height);
    }else {
        CGFloat height = YD_ScreenWidth;
        CGFloat width = height * ratio;
        self.player.containView.frame = CGRectMake(YD_ScreenWidth * 0.5 - width * 0.5, 0, width, height);
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.player.playerLayer.frame = self.player.containView.bounds;
    [CATransaction commit];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"宽高比";
}

- (NSString *)yd_barIconName {
    return self.model.barIconName ?: @"YD_Images.bundle/yd_aspectRatio";
}

- (void)yd_completeItemAction {
    
    [self.player yd_pause];
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    @weakify(self);
    [YD_AssetManager yd_aspectRatioAsset:self.model.asset ratio:self.selectRatio finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
        @strongify(self);
        
        [YD_ProgressHUD yd_hideHUD];
        if (isSuccess) {
            [self yd_pushPreview:exportPath];
        }else {
            [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
        }
    }];
}

@end
