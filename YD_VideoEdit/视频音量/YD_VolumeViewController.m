//
//  YD_VolumeViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_VolumeViewController.h"
#import "YD_VolumeSlider.h"
#import "YD_VolumeSwitchView.h"

@interface YD_VolumeViewController ()

@property (nonatomic, weak) YD_VolumeSlider *volumeSlider;

@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) YD_VolumeSwitchView *switchView_1;
@property (nonatomic, weak) YD_VolumeSwitchView *switchView_2;

@property (nonatomic, assign) CGFloat currentValue;

@end

@implementation YD_VolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)yd_setupConfig {
    [super yd_setupConfig];
    
    self.currentValue = 0.5;
    [self yd_volumeAsset];
}

- (void)yd_layoutSubViews {
    [super yd_layoutSubViews];
    {
        UIView *view = [UIView new];
        self.containView = view;
        [self.view addSubview:view];
    }
    {
        YD_VolumeSwitchView *sw = [YD_VolumeSwitchView new];
        self.switchView_1 = sw;
        sw.titleLbl.text = @"淡入";
        [sw.yd_switch addTarget:self action:@selector(yd_swichChange) forControlEvents:UIControlEventValueChanged];
        [self.containView addSubview:sw];
    }
    {
        YD_VolumeSwitchView *sw = [YD_VolumeSwitchView new];
        self.switchView_2 = sw;
        sw.titleLbl.text = @"淡出";
        [sw.yd_switch addTarget:self action:@selector(yd_swichChange) forControlEvents:UIControlEventValueChanged];
        [self.containView addSubview:sw];
    }
    {
        YD_VolumeSlider *slider = [YD_VolumeSlider new];
        self.volumeSlider = slider;
        slider.themeColor = self.model.themeColor;
        [self.view addSubview:slider];
    }
    
    @weakify(self);
    self.volumeSlider.endBlock = ^(CGFloat value) {
        @strongify(self);
        self.currentValue = value;
        
        [self yd_volumeAsset];
        self.player.yd_model = self.playModel;
    };
}

- (void)yd_layoutConstraints {
    [super yd_layoutConstraints];
    
    [self.volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomBar.mas_top);
        make.left.right.inset(0);
        make.height.mas_equalTo(64);
    }];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.equalTo(self.volumeSlider.mas_top);
        make.top.equalTo(self.player.mas_bottom);
    }];
    
    CGFloat height = MIN(YD_IPhone7_Width(32), 40);
    CGFloat margin = MIN(YD_IPhone7_Width(8), 10);
    [self.switchView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(15);
        make.height.mas_equalTo(height);
        make.bottom.equalTo(self.containView.mas_centerY).offset(-margin);
    }];
    
    [self.switchView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(15);
        make.height.mas_equalTo(height);
        make.top.equalTo(self.containView.mas_centerY).offset(margin);
    }];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"音量";
}

- (UIImage *)yd_barIconImage {
    return self.model.barIconImage ?: [UIImage yd_imageWithName:@"yd_volume@3x"];
}

- (void)yd_completeItemAction {
    [self.player yd_pause];

    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    @weakify(self);
    [YD_AssetManager yd_exporter:self.playModel.asset fileName:@"volume.mp4" composition:nil audioMix:self.playModel.audioMix finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
        @strongify(self);
        [YD_ProgressHUD yd_hideHUD];
        if (isSuccess) {
            [self yd_pushPreview:exportPath];
        }else {
            [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
        }
    }];
}

#pragma mark - 修改声音
- (void)yd_volumeAsset {
    NSDictionary *dict = [YD_AssetManager yd_volumeAsset:self.model.asset volume:self.currentValue fadeIn:self.switchView_1.yd_switch.isOn fadeOut:self.switchView_2.yd_switch.isOn];
    
    AVAsset *asset = dict[@"asset"];
    AVMutableAudioMix *audioMix = dict[@"audioMix"];

    self.playModel.asset = asset;
    self.playModel.audioMix = audioMix;
}

#pragma mark - UI事件
- (void)yd_swichChange {
    [self yd_volumeAsset];
    self.player.yd_model = self.playModel;
}

@end
