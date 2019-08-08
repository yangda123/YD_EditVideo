//
//  YD_PlayerFilterController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_PlayerFilterController.h"
#import "YD_PlayerFilterView.h"

@interface YD_PlayerFilterController ()

@property (nonatomic, weak) YD_PlayerFilterView *filterCollection;

@end

@implementation YD_PlayerFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)yd_layoutSubViews {
    [super yd_layoutSubViews];
    {
        YD_PlayerFilterView *view = [YD_PlayerFilterView new];
        self.filterCollection = view;
        view.image = [self.model.asset yd_getVideoImage:0];
        [self.view addSubview:view];
        
        @weakify(self);
        view.filterBlock = ^(NSString * filterName) {
            @strongify(self);
            self.player.filterName = filterName;
        };
    }
}

- (void)yd_layoutConstraints {
    [super yd_layoutConstraints];
    
    [self.filterCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.player.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
}

#pragma mark - 重写的方法
- (YD_PlayerLayerType)playerLayerType {
    return YD_PlayerLayerTypeFilter;
}

- (NSString *)yd_title {
    return @"滤镜";
}

- (UIImage *)yd_barIconImage {
    return self.model.barIconImage ?: [UIImage yd_imageWithName:@"yd_aspectRatio@3x"];
}

- (void)yd_completeItemAction {
    
    [self.player yd_pause];
    
    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
    
    CIFilter *filter = [CIFilter filterWithName:self.player.filterName];
    AVVideoComposition *composition = [AVVideoComposition videoCompositionWithAsset:self.model.asset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        CIImage *source = request.sourceImage.imageByClampingToExtent;
        [filter setValue:source forKey:kCIInputImageKey];
        CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];;
        [request finishWithImage:output context:nil];
    }];
    
    @weakify(self);
    [YD_AssetManager yd_exporter:self.model.asset fileName:@"filterVideo" composition:composition audioMix:nil finish:^(BOOL isSuccess, NSString * _Nonnull exportPath) {
        @strongify(self);
        [YD_ProgressHUD yd_hideHUD];
        if (isSuccess) {
            [self yd_pushPreview:exportPath];
        }else {
            [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
        }
    }];
}

//- (void)yd_completeItemAction {
//
//    [self.player yd_pause];
//
//    [YD_ProgressHUD yd_showHUD:@"正在处理视频，请不要锁屏或者切到后台"];
//
//    CIFilter *filter = [CIFilter filterWithName:self.player.filterName];
//    AVVideoComposition *composition = [AVVideoComposition videoCompositionWithAsset:self.model.asset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
//        CIImage *source = request.sourceImage.imageByClampingToExtent;
//        [filter setValue:source forKey:kCIInputImageKey];
//        CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];;
//        [request finishWithImage:output context:nil];
//    }];
//
//    NSString *filePath = [self videoOutputPath:@"filter"];
//    NSURL *outputUrl = [NSURL fileURLWithPath:filePath];   //输出路径
//    SDAVAssetExportSession *encoder = [SDAVAssetExportSession.alloc initWithAsset:self.model.asset];
//    encoder.outputFileType = AVFileTypeMPEG4;
//    encoder.outputURL = outputUrl;
//    encoder.videoComposition = composition;
//    //视频设置
//    encoder.videoSettings = @{
//                              AVVideoCodecKey: AVVideoCodecH264,
//                              AVVideoWidthKey: @720,
//                              AVVideoHeightKey: @1280,
//                              AVVideoCompressionPropertiesKey: @{
//                                      AVVideoAverageBitRateKey: @6000000,
//                                      AVVideoProfileLevelKey: AVVideoProfileLevelH264High40}
//                              };
//    //音频设置
//    encoder.audioSettings = @{
//                              AVFormatIDKey: @(kAudioFormatMPEG4AAC),
//                              AVNumberOfChannelsKey: @2,
//                              AVSampleRateKey: @44100,
//                              AVEncoderBitRateKey: @128000
//                              };
//    @weakify(self);
//    [encoder exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [YD_ProgressHUD yd_hideHUD];
//            @strongify(self);
//
//            if (encoder.status == AVAssetExportSessionStatusCompleted) {
//                [self yd_pushPreview:filePath];
//            }else {
//                [YD_ProgressHUD yd_showMessage:@"视频处理取消" toView:self.view];
//            }
//        });
//    }];
//}
//
//- (NSString *)videoOutputPath:(NSString *)fileName {
//    NSFileManager *manager = [NSFileManager defaultManager];
//    NSString *folderPath = [NSString stringWithFormat:@"%@/video", YD_PathDocument];
//    NSString *outputPath = [NSString stringWithFormat:@"%@/%@.mp4", folderPath, fileName];
//    if ([manager fileExistsAtPath:outputPath]) {
//        [manager removeItemAtPath:outputPath error:nil];
//    }
//
//    if (![manager fileExistsAtPath:folderPath]) {
//        [manager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    return outputPath;
//}

@end
