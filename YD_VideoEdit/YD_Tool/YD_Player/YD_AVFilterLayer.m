//
//  YD_AVFilterLayer.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_AVFilterLayer.h"
#import "YYWeakProxy.h"

@interface YD_AVFilterLayer ()

@property (nonatomic, strong) CADisplayLink *playLink;
@property (nonatomic, strong) AVPlayerItemVideoOutput *videoOutPut;
@property (nonatomic, strong) dispatch_queue_t renderQueue;
@property (nonatomic, strong) CIContext *context;

@end

@implementation YD_AVFilterLayer

- (void)dealloc {
    NSLog(@"------- YD_AVFilterLayer dealloc");
    if (_player) {
        [_player removeObserver:self forKeyPath:@"rate"];
        _player = nil;
    }
    [self invalidateLink];
    self.renderQueue = nil;
    self.context = nil;
    self.videoOutPut = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupConfig];
    }
    return self;
}

- (void)setupConfig {
    /// 播放的queue
    self.renderQueue = dispatch_queue_create("videoOutPut.queue", DISPATCH_QUEUE_SERIAL);
    /// 创建基于GPU的CIContext
    self.context = [CIContext contextWithOptions:nil];
    /// 输出流
    self.videoOutPut = [[AVPlayerItemVideoOutput alloc] init];
}

- (void)setPlayer:(AVPlayer *)player {
    if (_player == player) { return; }
    
    if (_player) {
        [_player removeObserver:self forKeyPath:@"rate"];
    }
    
    _player = player;
    
    [player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [player.currentItem addOutput:self.videoOutPut];
    [self initDisplayLink];
}

#pragma mark - 属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"rate"]) {
        CGFloat rate = [change[NSKeyValueChangeNewKey] doubleValue];
        self.playLink.paused = rate == 0.0;
    }
}

#pragma mark - setter
- (void)setFilterName:(NSString *)filterName {
    if (_filterName == filterName) {
        return;
    }
    _filterName = filterName;
    
    if (self.playLink.paused == NO) {
        return;
    }
    
    CMTime itemTime = [self.videoOutPut itemTimeForHostTime:CACurrentMediaTime()];
    [self reloadLayerContents:itemTime];
}

#pragma mark - 定时器相关
- (void)initDisplayLink {
    /// 释放定时器
    [self invalidateLink];
    
    self.playLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(playerRender)];
    self.playLink.paused = YES;
    [self.playLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)invalidateLink {
    if (self.playLink) {
        [self.playLink invalidate];
        self.playLink = nil;
    }
}

- (void)playerRender {
    CMTime itemTime = [self.videoOutPut itemTimeForHostTime:CACurrentMediaTime()];
    if ([self.videoOutPut hasNewPixelBufferForItemTime:itemTime]) {
        @weakify(self);
        dispatch_async(self.renderQueue, ^{
            @strongify(self);
            [self reloadLayerContents:itemTime];
        });
    }
}
/// 实时刷新界面
- (void)reloadLayerContents:(CMTime)itemTime {
    
    CVPixelBufferRef pixelBuffer = [self.videoOutPut copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIFilter *filter = [CIFilter filterWithName:self.filterName];
    [filter setDefaults];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    // 渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:[ciImage extent]];
        self.contents = (__bridge id)(cgImage);
        CGImageRelease(cgImage);
    });
    
    CVBufferRelease(pixelBuffer);
}

@end
