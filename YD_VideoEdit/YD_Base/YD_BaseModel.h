//
//  YD_BaseModel.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YD_VideoEditManager.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YD_BaseModel : NSObject
/// 顶部偏移:如果有需要，根据自己的要求设置
@property (nonatomic, assign) CGFloat yd_topOffsetY;
/// 当前控制器的背景色
@property (nonatomic, strong) UIColor *controllerColor;
/// 播放器背景色
@property (nonatomic, strong) UIColor *playerBackColor;
/// 导航栏的标题
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) AVAsset *asset;

@end

NS_ASSUME_NONNULL_END
