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
/// 底部bar图标的名称: 默认有图标，如果需要修改，自己传入icon名称
@property (nonatomic, copy) NSString *barIconName;
/// 视频播放
@property (nonatomic, strong) AVAsset *asset;

@end

NS_ASSUME_NONNULL_END
