//
//  AVAsset+YD_Extension.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AVAsset+YD_Extension.h"
#import "YD_CGAffineManager.h"

@implementation AVAsset (YD_Extension)

- (UIImage *)yd_getVideoImage:(NSTimeInterval)time {
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:self];
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    gen.appliesPreferredTrackTransform = YES;
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef imageRef = [gen copyCGImageAtTime:CMTimeMakeWithSeconds(time, 600) actualTime:&actualTime error:&error];
    UIImage *img = imageRef ? [[UIImage alloc] initWithCGImage:imageRef] : nil;
    CGImageRelease(imageRef);
    return img;
}

- (void)yd_getImagesCount:(NSUInteger)imageCount imageBackBlock:(void (^)(UIImage *image, CMTime actualTime))imageBackBlock {
    Float64 durationSeconds = [self yd_getSeconds];
    
    // 获取视频的帧数
    float fps = [self yd_getFPS];
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    
    Float64 perFrames = totalFrames / imageCount; // 一共切imageCount张图
    Float64 frame = 0;
    
    CMTime timeFrame;
    while (frame < totalFrames) {
        timeFrame = CMTimeMake(frame, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
        frame += perFrames;
    }
    
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self];
    // 防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imgGenerator.appliesPreferredTrackTransform = YES;  // 截图的时候调整到正确的方向
    
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                break;
            case AVAssetImageGeneratorFailed:
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *displayImage = [UIImage imageWithCGImage:image];
                !imageBackBlock ? : imageBackBlock(displayImage, actualTime);
            }
                break;
        }
    }];
}

- (void)yd_getAllImagesBlock:(void (^)(CGImageRef imageRef, UIImage *resultImg, CMTime actualTime))imageBackBlock {
    
    Float64 durationSeconds = [self yd_getSeconds];
    // 获取视频的帧数
    float fps = [self yd_getFPS];
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数

    for (int i = 1; i < totalFrames; i++) {
        CMTime timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self];
    // 防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imgGenerator.appliesPreferredTrackTransform = YES;  // 截图的时候调整到正确的方向
    
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                break;
            case AVAssetImageGeneratorFailed:
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *img = [UIImage imageWithCGImage:image];
                !imageBackBlock ? : imageBackBlock(image, img, actualTime);
            }
                break;
        }
    }];
}

- (Float64)yd_getSeconds {
    CMTime cmtime = self.duration; //视频时间信息结构体
    Float64 duration = CMTimeGetSeconds(cmtime);
    if (isnan(duration)) { duration = 0; }
    return duration; //视频总秒数
}

- (float)yd_getFPS {
    float fps = [[self tracksWithMediaType:AVMediaTypeVideo].lastObject nominalFrameRate];
    return fps;
}

- (CGSize)yd_naturalSize {
    NSArray *array = self.tracks;
    CGSize videoSize = CGSizeZero;
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    return videoSize;
}

- (BOOL)yd_assetReviseDirection {
    BOOL isChange = NO;
    if ([self tracksWithMediaType:AVMediaTypeVideo].count) {
        AVAssetTrack *videoAssetTrack = [self tracksWithMediaType:AVMediaTypeVideo].firstObject;
        
        CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
        if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
            isChange = YES;
        }
        
        if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
            isChange = YES;
        }
    }
    return isChange;
}

- (NSUInteger)yd_getAssetDegress {
    NSUInteger degress = 0;
    NSArray *tracks = [self tracksWithMediaType:AVMediaTypeVideo];
    if(tracks.count) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        degress = [YD_CGAffineManager yd_orientation:t];
    }
    
    return degress;
}

@end
