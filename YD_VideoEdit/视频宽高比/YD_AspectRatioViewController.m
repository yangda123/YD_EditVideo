//
//  YD_AspectRatioViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_AspectRatioViewController.h"
#import "YD_RatioView.h"

@interface YD_AspectRatioViewController ()

@property (nonatomic, weak) YD_RatioView *ratioView;

@end

@implementation YD_AspectRatioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)yd_layoutSubViews {
    [super yd_layoutSubViews];
    
    {
        self.player.containView.backgroundColor = UIColor.whiteColor;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(0, 0, YD_ScreenWidth, YD_ScreenWidth);
        imgView.image = self.playModel.coverImage;
        [self.player.containView insertSubview:imgView atIndex:0];
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = imgView.bounds;
        [imgView addSubview:effectview];
    }
    
    {
        YD_RatioView *ratioView = [[YD_RatioView alloc] initWithRatio:1.0];
        self.ratioView = ratioView;
        ratioView.themeColor = self.model.themeColor;
        [self.view addSubview:ratioView];
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

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"宽高比";
}

- (NSString *)yd_barIconName {
    return self.model.barIconName ?: @"yd_rotate";
}

- (void)yd_completeItemAction {
    
}

#pragma mark - UI事件

@end
