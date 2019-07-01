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

@interface YD_SpeedViewController () <YD_SliderViewwDelegate>

@property (nonatomic, strong)YD_DefaultPlayControlView * playControl;
@property (nonatomic, weak) YD_PlayerView *player;
@property (nonatomic, weak) YD_BottomBar *bottomBar;

@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) YD_SliderView *sliderView;

@property (nonatomic, strong) YD_PlayerModel *playModel;

@property (nonatomic, assign) BOOL is_change;

@end

@implementation YD_SpeedViewController

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
        self.model = [YD_SpeedModel new];
    }
    
    self.title = self.model.title;
    self.view.backgroundColor = self.model.controllerColor;
    
    self.playModel = [YD_PlayerModel new];
    self.playModel.asset = self.model.asset;
    self.playModel.coverImage = [self.model.asset yd_getVideoImage:0];
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
        [button addTarget:self action:@selector(yd_okItemAction) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        
        UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = okItem;
    }
    {
        self.playControl = [YD_DefaultPlayControlView new];
        @weakify(self);
        self.playControl.playBlock = ^{
            @strongify(self);

            if (self.is_change) {
                self.is_change = NO;
                self.player.yd_model = self.playModel;
                [self.player yd_play];
            }else {
                if (self.player.yd_playStatus == YD_PlayStatusPlay) {
                    [self.player yd_pause];
                }else if (self.player.yd_playStatus == YD_PlayStatusFinish) {
                    [self.player yd_replay];
                }else {
                    [self.player yd_play];
                }
            }
        };
    }
    {
        YD_PlayerView *player = [YD_PlayerView new];
        player.backgroundColor = self.model.playerBackColor;
        self.player = player;
        player.yd_model = self.playModel;
        player.yd_controlView = self.playControl;
        [self.view addSubview:player];
        
        [player yd_play];
    }
    {
        UIView *view = [UIView new];
        self.containView = view;
        [self.view addSubview:view];
        
        YD_SliderView *slider = [YD_SliderView new];
        self.sliderView = slider;
        slider.delegate = self;
        [view addSubview:slider];
    }
    {
        YD_BottomBar *bar = [YD_BottomBar addBar:@"变速" imgName:@"yd_change_speed"];
        self.bottomBar = bar;
        [self.view addSubview:bar];
    }
}

- (void)yd_layoutConstraints {
    
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.inset(0);
        make.height.equalTo(self.player.mas_width);
    }];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.player.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containView).offset(-10);
        make.left.right.inset(0);
    }];
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.inset(0);
        make.height.mas_equalTo(YD_BottomBarH);
    }];
}

#pragma mark - UI事件
- (void)yd_okItemAction {
    
    [YD_ProgressHUD yd_showHUD:@"正在保存视频"];
    AVAsset *asset = [YD_AssetManager yd_speedAssetWithAsset:self.model.asset speed:self.sliderView.currentSpeed];

    [YD_AssetManager yd_exporter:asset finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
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

#pragma mark - YD_SliderViewwDelegate
- (void)speedChange:(YD_SliderView *)slider speed:(CGFloat)speed {
    [self.player yd_seekToTime:0];
}

- (void)speedDidChange:(YD_SliderView *)slider speed:(CGFloat)speed {
    
    AVAsset *asset = [YD_AssetManager yd_speedAssetWithAsset:self.model.asset speed:self.sliderView.currentSpeed];
    self.playModel.asset = asset;
    self.is_change = YES;
}

@end
