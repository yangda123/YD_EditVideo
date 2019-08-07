//
//  YD_AssetManager.m
//  YD_SlowMotionVideo
//
//  Created by mac on 2019/6/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_AssetManager.h"
#import "YD_VideoEditManager.h"
#import "YD_PlayerView.h"

@implementation YD_AssetManager

+ (AVAsset *)yd_clipAssetWithUrl:(NSURL *)url startTime:(CGFloat)startTime endTime:(CGFloat)endTime {
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    CMTime star_time = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
    CMTime dutation = CMTimeMakeWithSeconds(endTime - startTime, asset.duration.timescale);
    
    CMTimeRange range = CMTimeRangeMake(star_time, dutation);
    
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
        [videoTrack insertTimeRange:range
                            ofTrack:videoAssetTrack
                             atTime:kCMTimeZero error:nil];
    }
    
    //2 音频通道
    if (audioAssetTrack) {
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:range
                            ofTrack:audioAssetTrack
                             atTime:kCMTimeZero error:nil];
    }
    
    return mixComposition;
}

+ (AVMutableVideoComposition *)yd_videoComposition:(AVAsset *)asset {
    
    AVAssetTrack *videoAssetTrack = nil;
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count) {
        videoAssetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    }
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetTrack.asset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:videoAssetTrack.asset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    return mainCompositionInst;
}

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

/// 视频复制拼接
+ (AVMutableComposition *)yd_copyAsset:(NSArray *)array {
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //1 视频通道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //2 音频通道
    AVMutableCompositionTrack *audioTrack;
    
    Float64 tmpDuration = 0.0;
    
    for (int i = 0; i < array.count; i++) {
        YD_PlayerModel *model = array[i];
        AVAsset *asset = model.asset;
        CMTimeRange range = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        AVAssetTrack *videoAssetTrack = nil;
        AVAssetTrack *audioAssetTrack = nil;
        
        if ([asset tracksWithMediaType:AVMediaTypeVideo].count) {
            videoAssetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        }
        
        if ([asset tracksWithMediaType:AVMediaTypeAudio].count) {
            audioAssetTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        }
        
        //1 视频通道
        if (videoAssetTrack) {
            [videoTrack insertTimeRange:range
                                ofTrack:videoAssetTrack
                                 atTime:CMTimeMakeWithSeconds(tmpDuration, 0) error:nil];
        }
        
        //2 音频通道
        if (audioAssetTrack) {
            if (!audioTrack) {
                audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            }
            
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:audioAssetTrack
                                 atTime:CMTimeMakeWithSeconds(tmpDuration, 0) error:nil];
            
        }
        
        tmpDuration += CMTimeGetSeconds(asset.duration);
    }
    
    return mixComposition;
}

/// 视频压缩
+ (void)yd_compressAsset:(AVAsset *)asset exportPreset:(NSString *)exportPreset finish:(YD_ExportFinishBlock)finishBlock {
    
    NSString *outputPath = [YD_PathCache stringByAppendingString:@"compress.mp4"];
    unlink([outputPath UTF8String]);
    /// 导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:exportPreset];
    
    exporter.outputURL = [NSURL fileURLWithPath:outputPath isDirectory:YES];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
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
    
    [self yd_exporter:mixComposition fileName:@"rotateVideo.mp4" composition:videoComposition audioMix:nil finish:finishBlock];
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
    
        [writer startSessionAtSourceTime:kCMTimeZero];
        
        NSMutableArray *samples = [[NSMutableArray alloc] init];
        CMSampleBufferRef sample;
        while ((sample = [readerOutput copyNextSampleBuffer])) {
            [samples addObject:(__bridge id)sample];
            CFRelease(sample);
        }

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
    
    [self yd_exporter:mixComposition fileName:@"aspect.mp4" composition:videoComposition audioMix:nil finish:finishBlock];
}

+ (NSDictionary *)yd_volumeAsset:(AVAsset *)asset
                          volume:(CGFloat)volume
                          fadeIn:(BOOL)fadeIn
                         fadeOut:(BOOL)fadeOut {
    
    //创建可变的音频视频组合
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    //视频音频range
    CMTimeRange range = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    //1 视频通道
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count) {
        AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        AVMutableCompositionTrack *videoCompositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [videoCompositionTrack insertTimeRange:range ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    }

    //2 音频通道
    AVMutableAudioMix *exportAudioMix = nil;
    if ([asset tracksWithMediaType:AVMediaTypeAudio].count) {
        //获取视频中的音频轨道
        AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        //初始化一个音频容器
        AVMutableCompositionTrack *audioCompositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        //插入音频到容器
        [audioCompositionTrack insertTimeRange:range ofTrack:audioTrack atTime:kCMTimeZero error:nil];
        //初始化音频混合器
        exportAudioMix = [AVMutableAudioMix audioMix];
        //获取混合后的音轨
        AVAssetTrack *mixCompositionTrack = [[mixComposition tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        //初始化音频混合器导出配置参数
        AVMutableAudioMixInputParameters *exportAudioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:mixCompositionTrack];
    
#pragma mark - 设置音量大小和淡入淡出的效果
        if (fadeIn == NO && fadeOut == NO) {
            [exportAudioMixInputParameters setVolume:volume atTime:kCMTimeZero];
        }else {
            CGFloat length = [asset yd_getSeconds];
            NSInteger fade_length = MIN(6, length * 0.3);
            CMTime continueTime = CMTimeMakeWithSeconds(fade_length, 1);
            //设置音乐淡入
            if (fadeIn) {
                [exportAudioMixInputParameters setVolumeRampFromStartVolume:0 toEndVolume:volume timeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(0, 1), continueTime)];
            }
            //设置音乐淡出
            if (fadeOut) {
                //计算开始淡出的时间
                CMTime fadeOutStartTime = CMTimeSubtract(asset.duration, continueTime);
                [exportAudioMixInputParameters setVolumeRampFromStartVolume:volume toEndVolume:0 timeRange:CMTimeRangeMake(fadeOutStartTime, continueTime)];
            }
        }
        
        //设置音频混合器参数
        NSArray *audioMixParameters = @[exportAudioMixInputParameters];
        exportAudioMix.inputParameters = audioMixParameters;
    }
    
    if (exportAudioMix) {
        return  @{@"asset" : mixComposition,
                  @"audioMix" : exportAudioMix};
    }
    
    return @{@"asset" : mixComposition};
}

#pragma mark - 视频导出
+ (void)yd_exporter:(AVAsset *)asset
           fileName:(NSString *)fileName
        composition:(AVVideoComposition *)composition
           audioMix:(AVMutableAudioMix *)audioMix
             finish:(YD_ExportFinishBlock)finishBlock {
    
    NSString *outputPath = [YD_PathCache stringByAppendingString:fileName];
    unlink([outputPath UTF8String]);
    /// 导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    if (audioMix) {
        exporter.audioMix = audioMix;
    }
    if (composition) {
        exporter.videoComposition = composition;
    }
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

#pragma mark - 保存到相册
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
