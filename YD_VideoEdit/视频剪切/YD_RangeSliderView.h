//
//  YD_RangeSliderView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

static NSInteger totalCount = 10;

@class YD_RangeSliderView;

@protocol YD_RangeSliderViewDelegate <NSObject>

@optional;
- (void)leftValueChange:(YD_RangeSliderView *_Nonnull)sliderView
                   time:(CGFloat)startTime;
- (void)rightValueChange:(YD_RangeSliderView *_Nonnull)sliderView
                    time:(CGFloat)endTime;

- (void)leftDidEndChange:(YD_RangeSliderView *_Nonnull)sliderView
                    time:(CGFloat)startTime;
- (void)rightDidEndChange:(YD_RangeSliderView *_Nonnull)sliderView
                     time:(CGFloat)endTime;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YD_RangeSliderView : YD_BaseView

- (instancetype)initWithAsset:(AVAsset *)asset;

@property (nonatomic, weak) id <YD_RangeSliderViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
