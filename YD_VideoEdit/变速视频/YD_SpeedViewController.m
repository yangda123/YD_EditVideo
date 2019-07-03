//
//  YD_SpeedViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_SpeedViewController.h"
#import "YD_PlayerView.h"
#import "YD_DefaultPlayControlView.h"
#import "YD_SliderView.h"
#import "YD_AssetManager.h"

@interface YD_SpeedViewController () <YD_SliderViewDelegate>

@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) YD_SliderView *sliderView;

@end

@implementation YD_SpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)yd_setupConfig {
    [super yd_setupConfig];
}

- (void)yd_layoutSubViews {
    [super yd_layoutSubViews];
    
    {
        UIView *view = [UIView new];
        self.containView = view;
        [self.view addSubview:view];
        
        YD_SliderView *slider = [YD_SliderView new];
        slider.themeColor = self.model.themeColor;
        self.sliderView = slider;
        slider.delegate = self;
        [view addSubview:slider];
    }
}

- (void)yd_layoutConstraints {
    [super yd_layoutConstraints];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.player.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containView).offset(-10);
        make.left.right.inset(0);
    }];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"变速";
}

- (UIImage *)yd_barIconImage {
    return self.model.barIconImage ?: [UIImage yd_imageWithName:@"yd_change_speed@3x"];
}

- (void)yd_completeItemAction {
    
    [self.player yd_pause];
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    @weakify(self);
    AVAsset *asset = [YD_AssetManager yd_speedAssetWithAsset:self.model.asset speed:self.sliderView.currentSpeed];

    [YD_AssetManager yd_exporter:asset fileName:@"speedVideo.mp4" finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
        @strongify(self);
        [YD_ProgressHUD yd_hideHUD];
        if (isSuccess) {
            [self yd_pushPreview:exportPath];
        }else {
            [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
        }
    }];
}

#pragma mark - YD_SliderViewwDelegate
- (void)speedChange:(YD_SliderView *)slider speed:(CGFloat)speed {
    [self.player yd_seekToTime:0];
}

- (void)speedDidChange:(YD_SliderView *)slider speed:(CGFloat)speed {
    AVAsset *asset = [YD_AssetManager yd_speedAssetWithAsset:self.model.asset speed:self.sliderView.currentSpeed];
    self.playModel.asset = asset;
    self.player.yd_model = self.playModel;
}

@end
