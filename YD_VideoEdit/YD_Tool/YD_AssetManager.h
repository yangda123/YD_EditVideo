//
//  YD_AssetManager.h
//  YD_SlowMotionVideo
//
//  Created by mac on 2019/6/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

typedef void(^YD_ExportFinishBlock)(BOOL isSuccess, NSString * _Nonnull exportPath);
NS_ASSUME_NONNULL_BEGIN

@interface YD_AssetManager : NSObject
/// 修改播放速度
+ (AVAsset *)yd_speedAssetWithAsset:(AVAsset *)asset speed:(CGFloat)speed;
/// 修改视频方向
+ (void)yd_rotateAssetWithAsset:(AVAsset *)asset degress:(NSInteger)degress finish:(YD_ExportFinishBlock)finishBlock;
/// 视频倒放
+ (void)yd_upendAsset:(AVAsset *)asset finish:(YD_ExportFinishBlock)finishBlock;
/// 视频宽高比 ratio = 宽 / 高
+ (void)yd_aspectRatioAsset:(AVAsset *)asset ratio:(CGFloat)ratio finish:(YD_ExportFinishBlock)finishBlock;

/// 导出视频
+ (void)yd_exporter:(AVAsset *)asset finish:(YD_ExportFinishBlock)finishBlock;
/// 保存到相册
+ (void)yd_saveToLibrary:(NSString *)savePath toView:(UIView *)view block:(void(^)(BOOL success))block;

@end

NS_ASSUME_NONNULL_END
