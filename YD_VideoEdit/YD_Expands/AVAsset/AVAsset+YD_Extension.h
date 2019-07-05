//
//  AVAsset+YD_Extension.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVAsset (YD_Extension)

/**
 *   获取每帧图片
 *
 *  @param time 获取截图的时间节点
 */
- (UIImage *)yd_getVideoImage:(NSTimeInterval)time;

/**
 *   获取每帧图片
 *
 *  @param imageCount     需要获取的图片个数
 *  @param imageBackBlock 得到一个图片时返回的block
 */
- (void)yd_getImagesCount:(NSUInteger)imageCount imageBackBlock:(void (^)(UIImage *image, CMTime actualTime))imageBackBlock;

/**
 *  获取视频的总秒数
 */
- (Float64)yd_getSeconds;

/** 获取fps */
- (float)yd_getFPS;

/** 获取size */
- (CGSize)yd_naturalSize;

/** 判断是否需要修正方向 */
- (BOOL)yd_assetReviseDirection;

/** 获取当前的方向 */
- (NSUInteger)yd_getAssetDegress;

@end

NS_ASSUME_NONNULL_END
