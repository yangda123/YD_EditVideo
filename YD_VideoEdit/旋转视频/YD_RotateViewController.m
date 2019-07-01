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

typedef NS_ENUM(NSInteger, YD_Orientation) {
    YD_OrientationUp    = 0,
    YD_OrientationRight = 90,
    YD_OrientationDown  = 180,
    YD_OrientationLeft  = 270
};


@interface YD_RotateViewController ()

@property (nonatomic, weak) YD_PlayerView *player;
@property (nonatomic, weak) YD_BottomBar *bottomBar;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.player.yd_viewControllerAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.yd_viewControllerAppear = NO;
}

- (void)yd_setupConfig {
    if (!self.model) {
        self.model = [YD_RotateModel new];
    }
    
    self.title = self.model.title;
    self.view.backgroundColor = self.model.controllerColor;
}

- (void)yd_layoutSubViews {
    
    UIColor *color = [UIColor colorWithHexString:@"#F61847"];
    
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 50, 18);
        button.backgroundColor = color;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(yd_rotateItemAction) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        
        UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = okItem;
    }
    {
        YD_PlayerModel *model = [YD_PlayerModel new];
        model.asset = self.model.asset;
        
        YD_PlayerView *player = [YD_PlayerView new];
        player.backgroundColor = self.model.playerBackColor;
        self.player = player;
        player.yd_model = model;
        player.yd_controlView = [YD_DefaultPlayControlView new];
        [self.view addSubview:player];
        
        [player yd_play];
    }
    {
        UIView *view = [UIView new];
        self.containView = view;
        [self.view addSubview:view];
        
        UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rotateBtn = rotateBtn;
        rotateBtn.backgroundColor = color;
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
        restoreBtn.layer.borderColor = color.CGColor;
        restoreBtn.layer.masksToBounds = YES;
        restoreBtn.layer.cornerRadius = 5;
        [restoreBtn setTitle:@"复 原" forState:UIControlStateNormal];
        [restoreBtn setTitleColor:color forState:UIControlStateNormal];
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
    {
        YD_BottomBar *bar = [YD_BottomBar addBar:@"旋转" imgName:@"yd_rotate"];
        self.bottomBar = bar;
        [self.view addSubview:bar];
    }
}

- (void)yd_layoutConstraints {
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.inset(self.model.yd_topOffsetY);
        make.height.equalTo(self.player.mas_width);
    }];
    
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
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.inset(0);
        make.height.mas_equalTo(YD_BottomBarH);
    }];
}

#pragma mark - UI事件
- (void)yd_rotateItemAction {
    
    [YD_ProgressHUD yd_showHUD:@"正在保存视频"];
    
    [YD_AssetManager  yd_rotateAssetWithAsset:self.model.asset degress:self.orientation finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
        
        if (isSuccess) {
            [YD_AssetManager yd_saveToLibrary:exportPath toView:self.view block:^(BOOL success) {
                [YD_ProgressHUD yd_hideHUD];
            }];
        }else {
            [YD_ProgressHUD yd_hideHUD];
            [YD_ProgressHUD yd_showMessage:@"保存失败" toView:self.view];
        }
    }];
}

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
