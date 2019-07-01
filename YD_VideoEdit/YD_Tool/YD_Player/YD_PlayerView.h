//
//  YD_PlayerView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, YD_PlayStatus) {
    YD_PlayStatusPreplay,
    YD_PlayStatusPlay,
    YD_PlayStatusPause,
    YD_PlayStatusStop,
    YD_PlayStatusFinish
};

NS_ASSUME_NONNULL_BEGIN

@class YD_PlayerView;
@class YD_PlayerModel;
@class YD_BasePlayControlView;

@protocol YD_PlayerViewDelegate <NSObject>

@optional
/// progress: 0 - 1
- (void)yd_player:(YD_PlayerView *_Nonnull)player currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
- (void)yd_player:(YD_PlayerView *_Nonnull)player playStateChanged:(YD_PlayStatus)status;

@end

@interface YD_PlayerView : YD_BaseView

@property (nonatomic, weak, readonly) UIView *containView;;
/// 播放状态
@property (assign, nonatomic, readonly) YD_PlayStatus yd_playStatus;
/// 控制界面
@property (nonatomic, strong) YD_BasePlayControlView *yd_controlView;
/// 代理
@property (nonatomic, weak) id<YD_PlayerViewDelegate> delegate;
/// 注意：：：在controller显示和消失的时候设置 
@property (nonatomic, assign) BOOL yd_viewControllerAppear;

@property (nonatomic, strong) YD_PlayerModel *yd_model;


/// 0 - 1
- (void)yd_playToTime:(CGFloat)value;
/// 0 - 1
- (void)yd_seekToTime:(CGFloat)value;

- (void)yd_play;
- (void)yd_pause;
- (void)yd_stop;
- (void)yd_replay;

@end

NS_ASSUME_NONNULL_END


@interface YD_PlayerModel : NSObject

@property (nonatomic, strong, nonnull) AVAsset *asset;
@property (nonatomic, strong, nonnull) UIImage *coverImage;
@property (nonatomic, assign) CGSize naturalSize;
@property (nonatomic, copy,   nonnull) AVLayerVideoGravity videoGravity;

@end
