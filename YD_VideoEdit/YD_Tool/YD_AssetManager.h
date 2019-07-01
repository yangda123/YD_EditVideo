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

+ (void)yd_rotateAssetWithAsset:(AVAsset *)asset degress:(NSInteger)degress finish:(YD_ExportFinishBlock)finishBlock;

+ (void)yd_exporter:(AVAsset *)asset finish:(YD_ExportFinishBlock)finishBlock;

+ (void)yd_saveToLibrary:(NSString *)savePath toView:(UIView *)view block:(void(^)(BOOL success))block;

@end

NS_ASSUME_NONNULL_END
