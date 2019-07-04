//
//  YD_ConfigModel.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YD_ConfigModel : NSObject

/// 当前控制器的背景色
@property (nonatomic, strong) UIColor *controllerColor;
/// 播放器背景色
@property (nonatomic, strong) UIColor *playerBackColor;
/// 主体的颜色
@property (nonatomic, strong) UIColor *themeColor;
/// 保存和分享字体的颜色
@property (nonatomic, strong) UIColor *btnTitleColor;

/// 底部bar图标: 默认有图标，如果需要修改，自己传入Image
@property (nonatomic, strong) UIImage *barIconImage;
/// 返回首页b图标: 默认有图标，如果需要修改，自己传入Image
@property (nonatomic, strong) UIImage *backHomeImage;

/// 视频播放（注意:这个我自己使用的）
@property (nonatomic, strong, readonly) AVAsset *asset;
/// 本地视频播放URL：这个是需要传入的
@property (nonatomic, strong) NSURL *videoURL;

@end

NS_ASSUME_NONNULL_END
