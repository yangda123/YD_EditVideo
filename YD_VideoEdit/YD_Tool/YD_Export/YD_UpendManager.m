//
//  YD_UpendManager.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_UpendManager.h"

@interface YD_UpendManager ()

@property (nonatomic, strong) AVAsset *asset;

@property (nonatomic, strong) AVAssetReaderTrackOutput *readerOutput;
@property (nonatomic, strong) AVAssetWriter *writer;
@property (nonatomic, strong) AVAssetWriterInput *writerInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor;

@end

@implementation YD_UpendManager

+ (void)yd_upendAsset:(AVAsset *)asset finish:(YD_ExportFinishBlock)finishBlock {
    YD_UpendManager *manager = [[YD_UpendManager alloc] initWithAsset:asset];
    
    dispatch_async(dispatch_queue_create("UpendVideoQueue", DISPATCH_QUEUE_SERIAL), ^{
        [manager yd_upendAsset:finishBlock];
    });
}

- (void)dealloc {
    NSLog(@"====== YD_UpendManager dealloc");
}

- (instancetype)initWithAsset:(AVAsset *)asset {
    self = [super init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (NSString *)yd_outputPaht {
    return [YD_PathCache stringByAppendingString:@"upendMovie.mp4"];
}

/// 初始化 reader 和 writer
- (NSError *)yd_setupReader {
    NSError *error;
    /// 读取视频流
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:self.asset error:&error];
    AVAssetTrack *videoTrack = [self.asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    /// 输出流相关设置
    NSDictionary *readerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange], kCVPixelBufferPixelFormatTypeKey, nil];
    /// 视频输出流
    self.readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:readerOutputSettings];
    self.readerOutput.alwaysCopiesSampleData = NO;
    // 在开始读取之前给reader指定一个output
    [reader addOutput:self.readerOutput];
    [reader startReading];
    /// 倒放视频路径
    NSString *outputPath = [self yd_outputPaht];
    // 删除当前该路径下的文件
    unlink([outputPath UTF8String]);
    NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
    /// 视频流写入
    self.writer = [[AVAssetWriter alloc] initWithURL:outputURL fileType:AVFileTypeMPEG4 error:&error];
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:@(videoTrack.estimatedDataRate), AVVideoAverageBitRateKey, nil];
    /// 写入流的设置
    NSDictionary *writerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                          AVVideoCodecH264, AVVideoCodecKey,
                                          [NSNumber numberWithInt:videoTrack.naturalSize.width], AVVideoWidthKey,
                                          [NSNumber numberWithInt:videoTrack.naturalSize.height], AVVideoHeightKey,
                                          videoCompressionProps, AVVideoCompressionPropertiesKey, nil];
    /// 视频输入流
    self.writerInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:writerOutputSettings sourceFormatHint:(__bridge CMFormatDescriptionRef)[videoTrack.formatDescriptions lastObject]];
    [self.writerInput setExpectsMediaDataInRealTime:NO];
    self.writerInput.transform = videoTrack.preferredTransform;
    
    self.pixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:self.writerInput sourcePixelBufferAttributes:nil];
    [self.writer addInput:self.writerInput];
    [self.writer startWriting];
    
    return error;
}

- (void)yd_upendAsset:(YD_ExportFinishBlock)finishBlock {
    /// 初始化
    NSError *error = [self yd_setupReader];
    
    Float64 seconds = [self.asset yd_getSeconds];
    float fps = [self.asset yd_getFPS];
    Float64 totalFrames = seconds * fps; //获得视频总帧数
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    gen.appliesPreferredTrackTransform = YES;
    
    [self.writer startSessionAtSourceTime:kCMTimeZero];
    
    for (int i = 0; i < totalFrames; i++) {
        @autoreleasepool {
            NSInteger j = totalFrames - 1 - i;
            CMTime time = CMTimeMake(i * 20, 600);
            CMTime imgTime = CMTimeMake(j * 20, 600);
            
            UIImage *img = [self yd_getVideoImage:imgTime gen:gen];
            CVPixelBufferRef imageBufferRef = [self pixelBufferFromCGImage:img.CGImage size:img.size];
            
            while (!self.writerInput.readyForMoreMediaData) {
                [NSThread sleepForTimeInterval:0.001];
            }
            [self.pixelBufferAdaptor appendPixelBuffer:imageBufferRef withPresentationTime:time];
            
            if (imageBufferRef) CFRelease(imageBufferRef);
        }
    }
    
    @weakify(self);
    [self.writer finishWritingWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (finishBlock) {
                finishBlock(!error, [self yd_outputPaht]);
                if (error) {  NSLog(@"----- %@", error); }
            }
        });
    }];
}

- (UIImage *)yd_getVideoImage:(CMTime)time gen:(AVAssetImageGenerator *)gen {
    CMTime actualTime;
    CGImageRef imageRef = [gen copyCGImageAtTime:time actualTime:&actualTime error:nil];
    UIImage *img = imageRef ? [[UIImage alloc] initWithCGImage:imageRef] : nil;
    CGImageRelease(imageRef);
    return img;
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],
                             kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES],
                             kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata !=NULL);
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    
//当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
    CGContextRef context = CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    //    当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    // 释放色彩空间
    CGColorSpaceRelease(rgbColorSpace);
    // 释放context
    CGContextRelease(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
}

@end
