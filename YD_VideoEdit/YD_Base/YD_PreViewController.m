//
//  YD_PreViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/2.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_PreViewController.h"
#import "YD_DefaultPlayControlView.h"
#import "YD_PlayerView.h"

@interface YD_PreViewController ()

@property (nonatomic, weak) YD_DefaultPlayControlView *playControl;
@property (nonatomic, weak) YD_PlayerView *player;

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIButton *saveBtn;
@property (nonatomic, weak) UIButton *shareBtn;

@end

@implementation YD_PreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"预览";
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.player.yd_viewControllerAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.yd_viewControllerAppear = NO;
}

- (void)yd_layoutSubViews {
    {
        UIImage *image = [[UIImage imageNamed:@"yd_pre_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(yd_homeItemAction)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    {
        UIView *view = [UIView new];
        self.bottomView = view;
        [self.view addSubview:view];
        
        self.saveBtn = [self yd_createButton:@"保存" imgName:@"yd_pre_save"];
        [self.saveBtn addTarget:self action:@selector(yd_saveAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.saveBtn];
        
        self.shareBtn = [self yd_createButton:@"分享" imgName:@"yd_pre_share"];
        [self.shareBtn addTarget:self action:@selector(yd_shareAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.shareBtn];
    }
    {
        YD_PlayerModel *model = [YD_PlayerModel new];
        model.asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:self.urlPath]];
        model.coverImage = [model.asset yd_getVideoImage:0];
        
        YD_DefaultPlayControlView *playControl = [YD_DefaultPlayControlView new];
        playControl.themeColor = self.themeColor;
        playControl.yd_hiddenBar = YES;
        self.playControl = playControl;
        
        YD_PlayerView *player = [YD_PlayerView new];
        self.player = player;
        player.backgroundColor = UIColor.whiteColor;
        player.yd_controlView = playControl;
        [self.view addSubview:player];
    
        player.yd_model = model;
        [player yd_play];
    }
}

- (UIButton *)yd_createButton:(NSString *)title imgName:(NSString *)imgName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5.0;
    button.layer.masksToBounds = YES;
    button.backgroundColor = self.themeColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    dispatch_async(dispatch_get_main_queue(), ^{
        [button layoutButtonWithEdgeInsetsStyle:YD_ButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    });
    return button;
}

- (void)yd_layoutConstraints {
    
    CGFloat topInset = self.navigationController.navigationBar.translucent ? YD_TopBarHeight : 0;
    
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.inset(topInset);
        make.height.equalTo(self.player.mas_width).multipliedBy(4/3.0);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.inset(0);
        make.top.mas_equalTo(self.player.mas_bottom);
    }];
    
    CGFloat margin = YD_IPhone7_Width(50);
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(36);
        make.left.inset(margin);
        make.centerY.equalTo(self.bottomView);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(36);
        make.right.inset(margin);
        make.centerY.equalTo(self.bottomView);
    }];
}

#pragma mark - UI事件
- (void)yd_homeItemAction {
    
    [self.player yd_pause];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定回到首页？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    [action_1 setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [action_2 setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    [alertController addAction:action_1];
    [alertController addAction:action_2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)yd_saveAction {
    if (self.saveBlock) {
        self.saveBlock(self, self.urlPath);
    }
}

- (void)yd_shareAction {
    if (self.shareBlock) {
        self.shareBlock(self, self.urlPath);
    }
}

@end
