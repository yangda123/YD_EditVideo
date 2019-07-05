//
//  YD_UpendViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_UpendViewController.h"
#import "YD_PlayerView.h"
#import "YD_DefaultPlayControlView.h"

@interface YD_UpendViewController ()

@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) UIButton *upendBtn;
@property (nonatomic, weak) UIButton *restoreBtn;
@property (nonatomic, weak) UILabel *titleLbl;

@property (nonatomic, strong) AVAsset *upendAsset;
/// 是否是倒放
@property (nonatomic, assign) BOOL isUpend;

@end

@implementation YD_UpendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)yd_layoutSubViews {
    
    [super yd_layoutSubViews];

    {
        UIView *view = [UIView new];
        self.containView = view;
        [self.view addSubview:view];
        
        UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.upendBtn = rotateBtn;
        rotateBtn.backgroundColor = self.model.themeColor;
        rotateBtn.layer.masksToBounds = YES;
        rotateBtn.layer.cornerRadius = 5;
        [rotateBtn setTitle:@"立即倒放" forState:UIControlStateNormal];
        [rotateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        rotateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [rotateBtn addTarget:self action:@selector(yd_upendAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:rotateBtn];
        
        UIButton *restoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.restoreBtn = restoreBtn;
        restoreBtn.layer.borderWidth = 1.0;
        restoreBtn.layer.borderColor = self.model.themeColor.CGColor;
        restoreBtn.layer.masksToBounds = YES;
        restoreBtn.layer.cornerRadius = 5;
        [restoreBtn setTitle:@"复 原" forState:UIControlStateNormal];
        [restoreBtn setTitleColor:self.model.themeColor forState:UIControlStateNormal];
        restoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [restoreBtn addTarget:self action:@selector(yd_restoreAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:restoreBtn];
        
        UILabel *label = [UILabel new];
        self.titleLbl = label;
        label.text = @"(视频倒放后将会没有声）";
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:10];
        [view addSubview:label];
    }
}

- (void)yd_layoutConstraints {

    [super yd_layoutConstraints];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.player.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
    
    [self.upendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView);
        make.centerY.equalTo(self.containView).offset(-40);
        make.width.mas_equalTo(132);
        make.height.mas_equalTo(36);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView);
        make.top.equalTo(self.upendBtn.mas_bottom).inset(6);
    }];
    
    [self.restoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containView);
        make.size.equalTo(self.upendBtn);
        make.top.equalTo(self.upendBtn.mas_bottom).inset(50);
    }];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"倒放";
}

- (UIImage *)yd_barIconImage {
    return self.model.barIconImage ?: [UIImage yd_imageWithName:@"yd_upend@3x"];
}

- (void)yd_completeItemAction {
    
    [self.player yd_pause];
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    @weakify(self);
    if (self.isUpend) {
        [YD_AssetManager yd_upendAsset:self.model.asset finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
            @strongify(self);
            [YD_ProgressHUD yd_hideHUD];
            if (isSuccess) {
                [self yd_pushPreview:exportPath];
            }else {
                [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
            }
        }];
    }else {
        [YD_AssetManager yd_exporter:self.model.asset fileName:@"upend.mp4" finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
            @strongify(self);
            [YD_ProgressHUD yd_hideHUD];
            if (isSuccess) {
                [self yd_pushPreview:exportPath];
            }else {
                [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
            }
        }];
    }
}

#pragma mark - UI事件
- (void)yd_upendAction {
    
    self.isUpend = YES;
    [self.player yd_pause];
    
    if (self.upendAsset) {
        [self yd_playWithAsset:self.upendAsset];
        return;
    }
    
//    CMTime time = self.model.asset.duration;
//    NSUInteger totalFrameCount = CMTimeGetSeconds(time) * [self.model.asset yd_getFPS];
//    [self.model.asset yd_getImagesCount:totalFrameCount imageBackBlock:^(UIImage * _Nonnull image, CMTime actualTime) {
//
//    }];
//
//    NSLog(@"========== %ld", totalFrameCount);
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];

    @weakify(self);
    [YD_AssetManager yd_upendAsset:self.model.asset finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
        @strongify(self);
        [YD_ProgressHUD yd_hideHUD];
        if (isSuccess) {
            self.upendAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:exportPath]];
            [self yd_playWithAsset:self.upendAsset];
        }else {
            [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
        }
    }];
}

- (void)yd_restoreAction {
    self.isUpend = NO;
    [self.player yd_pause];
    [self yd_playWithAsset:self.model.asset];
}

- (void)yd_playWithAsset:(AVAsset *)asset {
    self.playModel.asset = asset;
    self.player.yd_model = self.playModel;
    [self.player yd_play];
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
        
        CMSampleBufferRef sample = [readerOutput copyNextSampleBuffer];
        [writer startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sample)];
        
        CMTime time = asset.duration;
        NSUInteger totalFrameCount = CMTimeGetSeconds(time) * [asset yd_getFPS];
        NSUInteger i = 10;
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        while ((sample = [readerOutput copyNextSampleBuffer])) {
            
            i++;
            i = MIN(i, totalFrameCount);
            
            CMTime timeFrame = CMTimeMake(i * 20, 600);
            
            CMTime presentationTime = CMSampleBufferGetPresentationTimeStamp(sample);
            
            NSValue *value1 = [NSValue valueWithCMTime:presentationTime];
            NSValue *value2 = [NSValue valueWithCMTime:timeFrame];
            
            NSLog(@"---- %@", value1);
            NSLog(@"---===== %@", value2);
            
            [array addObject:@(0)];
            
            CVPixelBufferRef imageBufferRef = CMSampleBufferGetImageBuffer(sample);
            while (!writerInput.readyForMoreMediaData) {
                [NSThread sleepForTimeInterval:0.1];
            }
            [pixelBufferAdaptor appendPixelBuffer:imageBufferRef withPresentationTime:timeFrame];
            CFRelease(sample);
        }
        
        NSLog(@"!!!!!!!!!!!----- %ld", array.count);
        NSLog(@"!!!!!!!!!!!----- %ld", totalFrameCount);
        
        //        while ((sample = [readerOutput copyNextSampleBuffer])) {
        //            CMTime presentationTime = CMSampleBufferGetPresentationTimeStamp(sample);
        //            CVPixelBufferRef imageBufferRef = CMSampleBufferGetImageBuffer(sample);
        //            while (!writerInput.readyForMoreMediaData) {
        //                [NSThread sleepForTimeInterval:0.1];
        //            }
        //            [pixelBufferAdaptor appendPixelBuffer:imageBufferRef withPresentationTime:presentationTime];
        //
        //            CFRelease(sample);
        //        }
        
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









- (void)nativeTransferMovie:(AVAsset *)asset {

    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    CMTime time = asset.duration;
    NSUInteger totalFrameCount = CMTimeGetSeconds(time) * [asset yd_getFPS];
    NSMutableArray *timesArray = [NSMutableArray arrayWithCapacity:totalFrameCount];
    
    for (NSUInteger i = totalFrameCount - 1; i >= 0; i--) {
        CMTime timeFrame = CMTimeMake(i, [asset yd_getFPS]);
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [timesArray addObject:timeValue];
    }
    
////////////////////////////////////////////////////////////////////////////////////////////////
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
    
    [writer finishWritingWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [YD_ProgressHUD yd_hideHUD];
            NSLog(@"0000 ");
        });
    }];
    
////////////////////////////////////////////////////////////////////////////////////////////////

    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    [generator generateCGImagesAsynchronouslyForTimes:timesArray completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
    
        [writer startSessionAtSourceTime:requestedTime];
       
        CVPixelBufferRef imageBufferRef = [self pixelBufferFromCGImage:image];
        while (!writerInput.readyForMoreMediaData) {
            [NSThread sleepForTimeInterval:0.1];
        }
        [pixelBufferAdaptor appendPixelBuffer:imageBufferRef withPresentationTime:requestedTime];
    }];
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image {
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = CGImageGetWidth(image);
    CGFloat frameHeight = CGImageGetHeight(image);
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           frameWidth,
                                           frameHeight),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

@end

