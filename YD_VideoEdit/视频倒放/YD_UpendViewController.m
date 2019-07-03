//
//  YD_UpendViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_UpendViewController.h"
#import "YD_PlayerView.h"
#import "YD_DefaultPlayControlView.h"
#import "YD_AssetManager.h"

@interface YD_UpendViewController ()

@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) UIButton *upendBtn;
@property (nonatomic, weak) UIButton *restoreBtn;
@property (nonatomic, weak) UILabel *titleLbl;

@property (nonatomic, strong) AVAsset *upendAsset;
/// 是否是倒放
@property (nonatomic, assign) BOOL isUpend;

@end

@implementation YD_UpendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)yd_layoutSubViews {
    
    [super yd_layoutSubViews];

    {
        UIView *view = [UIView new];
        self.containView = view;
        [self.view addSubview:view];
        
        UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.upendBtn = rotateBtn;
        rotateBtn.backgroundColor = self.model.themeColor;
        rotateBtn.layer.masksToBounds = YES;
        rotateBtn.layer.cornerRadius = 5;
        [rotateBtn setTitle:@"立即倒放" forState:UIControlStateNormal];
        [rotateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        rotateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [rotateBtn addTarget:self action:@selector(yd_upendAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:rotateBtn];
        
        UIButton *restoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.restoreBtn = restoreBtn;
        restoreBtn.layer.borderWidth = 1.0;
        restoreBtn.layer.borderColor = self.model.themeColor.CGColor;
        restoreBtn.layer.masksToBounds = YES;
        restoreBtn.layer.cornerRadius = 5;
        [restoreBtn setTitle:@"复 原" forState:UIControlStateNormal];
        [restoreBtn setTitleColor:self.model.themeColor forState:UIControlStateNormal];
        restoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [restoreBtn addTarget:self action:@selector(yd_restoreAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:restoreBtn];
        
        UILabel *label = [UILabel new];
        self.titleLbl = label;
        label.text = @"(视频倒放后将会没有声）";
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:10];
        [view addSubview:label];
    }
}

- (void)yd_layoutConstraints {

    [super yd_layoutConstraints];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.player.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
    
    [self.upendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView);
        make.centerY.equalTo(self.containView).offset(-40);
        make.width.mas_equalTo(132);
        make.height.mas_equalTo(36);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView);
        make.top.equalTo(self.upendBtn.mas_bottom).inset(6);
    }];
    
    [self.restoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView);
        make.size.equalTo(self.upendBtn);
        make.top.equalTo(self.upendBtn.mas_bottom).inset(50);
    }];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"倒放";
}

- (UIImage *)yd_barIconImage {
    return self.model.barIconImage ?: [UIImage yd_imageWithName:@"yd_upend@3x"];
}

- (void)yd_completeItemAction {
    
    [self.player yd_pause];
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    @weakify(self);
    if (self.isUpend) {
        [YD_AssetManager yd_upendAsset:self.model.asset finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
            @strongify(self);
            [YD_ProgressHUD yd_hideHUD];
            if (isSuccess) {
                [self yd_pushPreview:exportPath];
            }else {
                [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
            }
        }];
    }else {
        [YD_AssetManager yd_exporter:self.model.asset fileName:@"upend.mp4" finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
            @strongify(self);
            [YD_ProgressHUD yd_hideHUD];
            if (isSuccess) {
                [self yd_pushPreview:exportPath];
            }else {
                [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
            }
        }];
    }
}

#pragma mark - UI事件
- (void)yd_upendAction {
    
    self.isUpend = YES;
    [self.player yd_pause];
    
    if (self.upendAsset) {
        [self yd_playWithAsset:self.upendAsset];
        return;
    }
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    @weakify(self);
    [YD_AssetManager yd_upendAsset:self.model.asset finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
        @strongify(self);
        [YD_ProgressHUD yd_hideHUD];
        if (isSuccess) {
            self.upendAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:exportPath]];
            [self yd_playWithAsset:self.upendAsset];
        }else {
            [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
        }
    }];
}

- (void)yd_restoreAction {
    self.isUpend = NO;
    [self.player yd_pause];
    [self yd_playWithAsset:self.model.asset];
}

- (void)yd_playWithAsset:(AVAsset *)asset {
    self.playModel.asset = asset;
    self.player.yd_model = self.playModel;
    [self.player yd_play];
}

@end

