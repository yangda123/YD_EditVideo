//
//  YD_CompressViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_CompressViewController.h"
#import "YD_CompressView.h"

@interface YD_CompressViewController ()

@property (nonatomic, weak) YD_CompressView *compressView;

@end

@implementation YD_CompressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)yd_layoutSubViews {
    [super yd_layoutSubViews];
    
    NSData *data = [NSData dataWithContentsOfURL:self.model.videoURL];
    CGFloat totalSize = data.length / 1024.0 / 1024.0;
   
    YD_CompressView *view = [YD_CompressView new];
    self.compressView = view;
    view.fileSize = totalSize;
    view.themeColor = self.model.themeColor;
    [self.view addSubview:view];
}

- (void)yd_layoutConstraints {
    [super yd_layoutConstraints];
    
    [self.compressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.player.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"压缩";
}

- (UIImage *)yd_barIconImage {
    return self.model.barIconImage ?: [UIImage yd_imageWithName:@"yd_compress@3x"];
}

- (void)yd_completeItemAction {
    
    [self.player yd_pause];
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    @weakify(self);
    [YD_AssetManager yd_compressAsset:self.model.asset exportPreset:[self.compressView yd_assetExportPreset] finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
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
