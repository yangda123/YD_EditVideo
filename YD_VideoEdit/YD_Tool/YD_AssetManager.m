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
/// 调整播放速度
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
/// 视频旋转
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
    
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction, nil];
    videoComposition.instructions = [NSArray arrayWithObject:mainInstruction];
    
    [self yd_exporter:mixComposition videoComposition:videoComposition finish:finishBlock];
}
/// 视频倒放
+ (void)yd_upendAsset:(AVAsset *)asset finish:(YD_ExportFinishBlock)finishBlock {
    
    dispatch_async(dispatch_queue_create("UpendMovieQueue", DISPATCH_QUEUE_SERIAL), ^{
        NSError *error;
        AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
        AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        NSDictionary *readerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange], kCVPixelBufferPixelFormatTypeKey, nil];
        AVAssetReaderTrackOutput *readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:readerOutputSettings];
        readerOutput.alwaysCopiesSampleData = NO;
        // 在开始读取之前给reader指定一个output
        [reader addOutput:readerOutput];
        [reader startReading];
        
        NSMutableArray *samples = [[NSMutableArray alloc] init];
        CMSampleBufferRef sample;
        while ((sample = [readerOutput copyNextSampleBuffer])) {
            [samples addObject:(__bridge id)sample];
            CFRelease(sample);
        }
        
        NSString *outputPath = [YD_PathCache stringByAppendingString:@"upendMovie.mp4"];
        // 删除当前该路径下的文件
        unlink([outputPath UTF8String]);
        NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
        
        AVAssetWriter *writer = [[AVAssetWriter alloc] initWithURL:outputURL fileType:AVFileTypeMPEG4 error:&error];
        NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:@(videoTrack.estimatedDataRate), AVVideoAverageBitRateKey, nil];
        NSDictionary *writerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                              AVVideoCodecH264, AVVideoCodecKey,
                                              [NSNumber numberWithInt:videoTrack.naturalSize.width], AVVideoWidthKey,
                                              [NSNumber numberWithInt:videoTrack.naturalSize.height], AVVideoHeightKey,
                                              videoCompressionProps, AVVideoCompressionPropertiesKey, nil];
        AVAssetWriterInput *writerInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:writerOutputSettings sourceFormatHint:(__bridge CMFormatDescriptionRef)[videoTrack.formatDescriptions lastObject]];
        [writerInput setExpectsMediaDataInRealTime:NO];
        writerInput.transform = videoTrack.preferredTransform;
        
        AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:writerInput sourcePixelBufferAttributes:nil];
        [writer addInput:writerInput];
        [writer startWriting];
        [writer startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp((__bridge CMSampleBufferRef)samples[0])];
        for (NSInteger i = 0; i < samples.count; i ++) {
            CMTime presentationTime = CMSampleBufferGetPresentationTimeStamp((__bridge CMSampleBufferRef)samples[i]);
            CVPixelBufferRef imageBufferRef = CMSampleBufferGetImageBuffer((__bridge CMSampleBufferRef)samples[samples.count - i - 1]);
            while (!writerInput.readyForMoreMediaData) {
                [NSThread sleepForTimeInterval:0.1];
            }
            [pixelBufferAdaptor appendPixelBuffer:imageBufferRef withPresentationTime:presentationTime];
        }
        
        [writer finishWritingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finishBlock) {
                    finishBlock(!error, outputPath);
                    if (error) {  NSLog(@"----- %@", error); }
                }
            });
        }];
    });
}
/// 视频宽高比
+ (void)yd_aspectRatioAsset:(AVAsset *)asset ratio:(CGFloat)ratio finish:(YD_ExportFinishBlock)finishBlock {
    
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
    
    CGSize naturalSize = videoAssetTrack.naturalSize;
    /// 当宽大于等于高
    CGSize resultSize = CGSizeMake(videoAssetTrack.naturalSize.width, videoAssetTrack.naturalSize.width / ratio);
    /// 当高大于宽
    if (naturalSize.width < naturalSize.height) {
        resultSize = CGSizeMake(videoAssetTrack.naturalSize.height * ratio, videoAssetTrack.naturalSize.height);
    }
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    videoComposition.renderSize = resultSize;
    
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.asset.duration);
    
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction, nil];
    videoComposition.instructions = [NSArray arrayWithObject:mainInstruction];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    /// 当高大于宽
    if (naturalSize.width < naturalSize.height) {
        CGFloat height = resultSize.height;
        CGFloat width = height * naturalSize.width / naturalSize.height;
        parentLayer.frame = CGRectMake(resultSize.width * 0.5 - width * 0.5, 0, width, height);
    }else {
        /// 当宽大于等于高
        CGFloat width = resultSize.width;
        CGFloat height = width * naturalSize.height / naturalSize.width;
        parentLayer.frame = CGRectMake(0, height * 0.5 - resultSize.height * 0.5, width, height);
    }
    
    videoLayer.frame = CGRectMake(0, 0, resultSize.width, resultSize.height);
    videoLayer.contentsGravity = kCAGravityResizeAspect;
    [parentLayer addSublayer:videoLayer];
    // 单个画面播放
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
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
