//
//  YD_PlayerView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_PlayerView.h"
#import "YD_BasePlayControlView.h"

@interface YD_PlayerView ()

@property (nonatomic, weak)   UIImageView *imgView;
@property (nonatomic, weak)   UIView *containView;
@property (nonatomic, weak)   AVPlayerLayer *playerLayer;
@property (nonatomic, weak)   AVPlayer *player;
@property (nonatomic, assign) YD_PlayStatus yd_playStatus;

@end

@implementation YD_PlayerView

- (void)dealloc {
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:NULL];
        [AVAudioSession.sharedInstance setActive:true error:NULL];

        [self yd_addObserver];
        [self yd_layoutSubViews];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self yd_stop];
    }
}

#pragma mark - 初始化UI
- (void)yd_layoutSubViews {
    {
        UIView *view = [UIView new];
        self.containView = view;
        [self addSubview:view];
    }
    {
        AVPlayerLayer *playerLayer = [[AVPlayerLayer alloc] init];
        self.playerLayer = playerLayer;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.containView.layer addSublayer:playerLayer];
    }
    {
        UIImageView *imgView = [[UIImageView alloc] init];
        self.imgView = imgView;
        imgView.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
    }
}

- (void)layoutSubviews {
    self.containView.frame = self.bounds;
    self.imgView.frame = self.bounds;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.playerLayer.frame = self.containView.bounds;
    [CATransaction commit];
}

/// 获取当前播放视频总时长
- (NSTimeInterval)yd_totalDuration {
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(duration)) { duration = 0; }
    return duration;
}

#pragma mark - setter
- (void)setYd_controlView:(YD_BasePlayControlView *)yd_controlView {
    if (!yd_controlView) { return; }
    _yd_controlView = yd_controlView;
    yd_controlView.player = self;
    [self addSubview:yd_controlView];
    
    [yd_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
}

- (void)setYd_playStatus:(YD_PlayStatus)yd_playStatus {
    
    if (_yd_playStatus == yd_playStatus) { return; }
    
    _yd_playStatus = yd_playStatus;
    if ([self.delegate respondsToSelector:@selector(yd_player:playStateChanged:)]) {
        [self.delegate yd_player:self playStateChanged:yd_playStatus];
    }
    if ([self.yd_controlView respondsToSelector:@selector(yd_player:playStateChanged:)]) {
        [self.yd_controlView yd_player:self playStateChanged:yd_playStatus];
    }
}

- (void)setYd_viewControllerAppear:(BOOL)yd_viewControllerAppear {
    if (yd_viewControllerAppear) {
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(yd_playToEndTimeNotification) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        if (self.yd_playStatus == YD_PlayStatusPlay) {
            [self.player play];
        }
    }else {
        [NSNotificationCenter.defaultCenter removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        [self.player pause];
    }
}

- (void)setYd_model:(YD_PlayerModel *)yd_model {
    _yd_model = yd_model;
    
    self.yd_playStatus = YD_PlayStatusPreplay;
    
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    self.imgView.hidden = NO;
    self.imgView.image = yd_model.coverImage;
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:yd_model.asset];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.playerLayer.player = self.player;
    self.playerLayer.videoGravity = yd_model.videoGravity;

    @weakify(self);
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self);
        [self yd_playeProgressChange];
    }];
}

- (void)yd_playeProgressChange {
    if ([self.delegate respondsToSelector:@selector(yd_player:currentTime:totalTime:)]) {
        [self.delegate yd_player:self currentTime:CMTimeGetSeconds(self.player.currentItem.currentTime) totalTime:[self yd_totalDuration]];
    }
    if ([self.yd_controlView respondsToSelector:@selector(yd_player:currentTime:totalTime:)]) {
        [self.yd_controlView yd_player:self currentTime:CMTimeGetSeconds(self.player.currentItem.currentTime) totalTime:[self yd_totalDuration]];
    }
}

#pragma mark - 暂停 播放
- (void)yd_playToTime:(CGFloat)value {
    
    [self yd_pause];
    
    NSTimeInterval time = [self yd_totalDuration] * value;
    
    @weakify(self);
    [self.player.currentItem seekToTime:CMTimeMake(time, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        @strongify(self);
        if (finished) {
            [self yd_play];
        }
    }];
}

- (void)yd_seekToTime:(CGFloat)value {
    /// 先暂停
    [self yd_pause];
    /// 再设置
    if (value == 1.0) {
        _yd_playStatus = YD_PlayStatusFinish;
    }
    
    NSTimeInterval time = [self yd_totalDuration] * value;
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)yd_play {
    self.yd_playStatus = YD_PlayStatusPlay;
    if (self.player.rate == 0) {
        [self.player play];
    }
}

- (void)yd_pause {
    self.yd_playStatus = YD_PlayStatusPause;
    if (self.player.rate != 0) {
        [self.player pause];
    }
}

- (void)yd_stop {
    self.yd_playStatus = YD_PlayStatusStop;
    if (self.player) {
        [self.player pause];
    }
}

- (void)yd_replay {
    @weakify(self);
    [self.player.currentItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        @strongify(self);
        if (finished) {
            [self yd_play];
        }
    }];
}

#pragma mark - 属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            [self yd_playeProgressChange];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.imgView.hidden = YES;
            });
        }
    }
}

#pragma mark - 添加通知
- (void)yd_addObserver {
    @weakify(self);
    [[[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if (self.yd_playStatus == YD_PlayStatusPlay) {
            [self.player play];
        }
    }];
    
    [[[NSNotificationCenter.defaultCenter rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self.player pause];
    }];
}

- (void)yd_playToEndTimeNotification {
    if (self.yd_playStatus == YD_PlayStatusPlay) {
        self.yd_playStatus = YD_PlayStatusFinish;
    }
}

@end

@implementation YD_PlayerModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return self;
}

@end
