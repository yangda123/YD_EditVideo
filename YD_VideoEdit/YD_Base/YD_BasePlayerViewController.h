//
//  YD_BasePlayerViewController.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseViewController.h"
#import "YD_DefaultPlayControlView.h"
#import "YD_PlayerView.h"
#import "YD_ConfigModel.h"
#import "YD_PreViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_BasePlayerViewController : YD_BaseViewController

@property (nonatomic, strong) YD_ConfigModel *model;

@property (nonatomic, strong, readonly) YD_PlayerModel *playModel;
@property (nonatomic, weak, readonly) YD_DefaultPlayControlView *playControl;
@property (nonatomic, weak, readonly) YD_PlayerView *player;
@property (nonatomic, weak, readonly) YD_BottomBar *bottomBar;

#pragma mark - 分享和保存的回掉
@property (nonatomic, copy) YD_SaveBlock  saveBlock;
@property (nonatomic, copy) YD_ShareBlock shareBlock;

#pragma mark - 子类需要重写的方法
/// 标题
- (NSString *)yd_title;
/// 底部bar图标名称
- (UIImage *)yd_barIconImage;
/// 点击完成的处理
- (void)yd_completeItemAction;

#pragma mark - 跳到预览界面
- (void)yd_pushPreview:(NSString *)urlPath;

@end

NS_ASSUME_NONNULL_END

