//
//  YD_RotateViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_RotateViewController.h"
#import "YD_PlayerView.h"
#import "YD_DefaultPlayControlView.h"
#import "YD_AssetManager.h"

@interface YD_RotateViewController ()

@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) UIButton *rotateBtn;
@property (nonatomic, weak) UIButton *restoreBtn;
@property (nonatomic, weak) UILabel *titleLbl;

@property (nonatomic, assign) YD_Orientation orientation;

@end

@implementation YD_RotateViewController

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
        self.rotateBtn = rotateBtn;
        rotateBtn.backgroundColor = self.model.themeColor;
        rotateBtn.layer.masksToBounds = YES;
        rotateBtn.layer.cornerRadius = 5;
        [rotateBtn setTitle:@"立即旋转" forState:UIControlStateNormal];
        [rotateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        rotateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [rotateBtn addTarget:self action:@selector(yd_rotateAction) forControlEvents:UIControlEventTouchUpInside];
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
        label.text = @"(视频将以90°旋转一次）";
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
    
    [self.rotateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView);
        make.centerY.equalTo(self.containView).offset(-40);
        make.width.mas_equalTo(132);
        make.height.mas_equalTo(36);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView);
        make.top.equalTo(self.rotateBtn.mas_bottom).inset(6);
    }];
    
    [self.restoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView);
        make.size.equalTo(self.rotateBtn);
        make.top.equalTo(self.rotateBtn.mas_bottom).inset(50);
    }];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"旋转";
}

- (NSString *)yd_barIconName {
    return self.model.barIconName ?: @"YD_Images.bundle/yd_rotate";
}

- (void)yd_completeItemAction {
    
    [self.player yd_pause];
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    @weakify(self);
    [YD_AssetManager  yd_rotateAssetWithAsset:self.model.asset degress:self.orientation finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
        @strongify(self);
        [YD_ProgressHUD yd_hideHUD];
        if (isSuccess) {
            [self yd_pushPreview:exportPath];
        }else {
            [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
        }
    }];
}

#pragma mark - UI事件
- (void)yd_rotateAction {
    
    if (self.orientation == YD_OrientationUp) {
        self.orientation = YD_OrientationRight;
    }else if (self.orientation == YD_OrientationRight) {
        self.orientation = YD_OrientationDown;
    }else if (self.orientation == YD_OrientationDown) {
        self.orientation = YD_OrientationLeft;
    }else if (self.orientation == YD_OrientationLeft) {
        self.orientation = YD_OrientationUp;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.player.containView.transform = CGAffineTransformRotate(self.player.containView.transform, M_PI * 0.5);
    }];
}

- (void)yd_restoreAction {
    self.orientation = YD_OrientationUp;
    [UIView animateWithDuration:0.2 animations:^{
        self.player.containView.transform = CGAffineTransformIdentity;
    }];
}

@end
