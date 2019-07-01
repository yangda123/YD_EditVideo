//
//  YD_AssetManager.m
//  YD_SlowMotionVideo
//
//  Created by mac on 2019/6/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_AssetManager.h"
#import "YD_VideoEditManager.h"

@implementation YD_AssetManager

+ (AVAsset *)yd_speedAssetWithAsset:(AVAsset *)asset speed:(CGFloat)speed {
    
    CMTimeRange range = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    AVAssetTrack *videoAssetTrack = nil;
    AVAssetTrack *audioAssetTrack = nil;
    
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count) {
        videoAssetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    }
    if ([asset tracksWithMediaType:AVMediaTypeAudio].count) {
        audioAssetTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    }
    
    CMTimeValue speed_value = asset.duration.value / speed;
    //1 视频通道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    if (videoAssetTrack) {
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:videoAssetTrack
                             atTime:kCMTimeZero error:nil];
#pragma mark 在这里修改快放速度
        [videoTrack scaleTimeRange:range toDuration:CMTimeMake(speed_value, asset.duration.timescale)];
    }
    
    //2 音频通道
    if (audioAssetTrack) {
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:audioAssetTrack
                             atTime:kCMTimeZero error:nil];
#pragma mark 在这里修改快放速度
        [audioTrack scaleTimeRange:range toDuration:CMTimeMake(speed_value, asset.duration.timescale)];
    }
    
    return mixComposition;
}

+ (void)yd_rotateAssetWithAsset:(AVAsset *)asset degress:(NSInteger)degress finish:(YD_ExportFinishBlock)finishBlock {

    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    AVAssetTrack *videoAssetTrack = nil;
    AVAssetTrack *audioAssetTrack = nil;
    
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count) {
        videoAssetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    }
    if ([asset tracksWithMediaType:AVMediaTypeAudio].count) {
        audioAssetTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    }
    
    //1 视频通道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    if (videoAssetTrack) {
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:videoAssetTrack
                             atTime:kCMTimeZero error:nil];
    }
    
    //2 音频通道
    if (audioAssetTrack) {
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:audioAssetTrack
                             atTime:kCMTimeZero error:nil];
    }
    
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    videoComposition.renderSize = videoAssetTrack.naturalSize;
    
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.asset.duration);
    
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];

    if ([asset yd_assetReviseDirection]) {
        videoTrack.preferredTransform =  CGAffineTransformMakeRotation(-M_PI_2);
    }
    
    degress = ([asset yd_getAssetDegress] + degress) % 360;
    
    CGSize naturalSize = videoAssetTrack.naturalSize;
    // 旋转视频
    if (degress == 90) {
        CGAffineTransform t1 = CGAffineTransformMakeTranslation(naturalSize.height, 0.0);
        CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
        [videolayerInstruction setTransform:t2 atTime:kCMTimeZero];
        videoComposition.renderSize = CGSizeMake(naturalSize.height, naturalSize.width);
    }else if (degress == 180) {
        CGAffineTransform t1 = CGAffineTransformMakeTranslation(naturalSize.width, naturalSize.height);
        CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI);
        [videolayerInstruction setTransform:t2 atTime:kCMTimeZero];
        videoComposition.renderSize = naturalSize;
    }else if (degress == 270) {
        CGAffineTransform t1 = CGAffineTransformMakeTranslation(0.0, naturalSize.width);
        CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI * 1.5);
        [videolayerInstruction setTransform:t2 atTime:kCMTimeZero];
        videoComposition.renderSize = CGSizeMake(naturalSize.height, naturalSize.width);
    }else if (degress == 0) {
        videoComposition.renderSize = naturalSize;
    }
    
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    videoComposition.instructions = [NSArray arrayWithObject:mainInstruction];
    
    [self yd_exporter:mixComposition videoComposition:videoComposition finish:finishBlock];
}

+ (void)yd_exporter:(AVAsset *)asset
   videoComposition:(AVMutableVideoComposition *)videoComposition
             finish:(YD_ExportFinishBlock)finishBlock {
    
    NSString *outputPath = [YD_PathCache stringByAppendingString:@"rotateVideo.mp4"];
    unlink([outputPath UTF8String]);
    /// 导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = [NSURL fileURLWithPath:outputPath isDirectory:YES];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) {
                BOOL isOk = (!exporter.error && exporter.status == AVAssetExportSessionStatusCompleted);
                finishBlock(isOk, outputPath);
                
                if (exporter.error) {
                    NSLog(@"----- %@", exporter.error);
                }
            }
        });
    }];
}

+ (void)yd_exporter:(AVAsset *)asset finish:(YD_ExportFinishBlock)finishBlock {
 
    NSString *outputPath = [YD_PathCache stringByAppendingString:@"speedVideo.mp4"];
    unlink([outputPath UTF8String]);
    /// 导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    
    exporter.outputURL = [NSURL fileURLWithPath:outputPath isDirectory:YES];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) {
                BOOL isOk = (!exporter.error && exporter.status == AVAssetExportSessionStatusCompleted);
                finishBlock(isOk, outputPath);
                
                if (exporter.error) {
                    NSLog(@"----- %@", exporter.error);
                }
            }
        });
    }];
}

+ (void)yd_saveToLibrary:(NSString *)savePath toView:(UIView *)view block:(void(^)(BOOL success))block {
    
    PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    [photoLibrary performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:savePath]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (block) { block(success); }
    
            if (success) {
                [YD_ProgressHUD yd_showMessage:@"保存成功" toView:view];
            } else {
                [YD_ProgressHUD yd_showMessage:@"保存失败" toView:view];
            }
        });
    }];
}

@end
