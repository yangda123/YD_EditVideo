//
//  YD_CopyViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_CopyViewController.h"
#import "YD_CopyView.h"

@interface YD_CopyViewController ()

@property (nonatomic, weak) YD_CopyView *yd_copyView;

@property (nonatomic, strong) AVAsset *currentAsset;

@end

@implementation YD_CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)yd_setupConfig {
    [super yd_setupConfig];
    self.currentAsset = self.model.asset;
}

- (void)yd_layoutSubViews {
    [super yd_layoutSubViews];
    
    YD_CopyView *view = [[YD_CopyView alloc] initWithModel:self.playModel];
    self.yd_copyView = view;
    view.themeColor = self.model.themeColor;
    [self.view addSubview:view];
    
    @weakify(self);
    view.copyBlock = ^(NSArray * _Nonnull modelArr, BOOL flag) {
        @strongify(self);
        
        if (flag == NO) {
            [YD_ProgressHUD yd_showMessage:@"视频总时长不能超过一小时" toView:self.view];
            return;
        }
        
        self.currentAsset = [YD_AssetManager yd_copyAsset:modelArr];
        YD_PlayerModel *model = [YD_PlayerModel new];
        model.asset = self.currentAsset;
        model.coverImage = self.playModel.coverImage;
        model.smallImage = self.playModel.smallImage;
        
        self.player.yd_model = model;
    };
}

- (void)yd_layoutConstraints {
    [super yd_layoutConstraints];
    
    [self.yd_copyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.player.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"复制";
}

- (UIImage *)yd_barIconImage {
    
    return self.model.barIconImage ?: [UIImage yd_imageWithName:@"yd_copy@3x"];
}

- (void)yd_completeItemAction {
    [self.player yd_pause];
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    @weakify(self);
    [YD_AssetManager yd_exporter:self.currentAsset fileName:@"copy" composition:nil audioMix:nil finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
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
