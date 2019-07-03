//
//  YD_TwoWaySlider.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

@class YD_TwoWaySlider;

@protocol YD_TwoWaySliderDelegate <NSObject>

@optional
/// value: 0 - 1
- (void)sliderValueChange:(YD_TwoWaySlider *_Nonnull)slider
                    value:(CGFloat)value;
- (void)sliderDidEndChange:(YD_TwoWaySlider *_Nonnull)slider
                     value:(CGFloat)value;

@end

static CGFloat twoWaySliderH = 50;

NS_ASSUME_NONNULL_BEGIN

@interface YD_TwoWaySlider : YD_BaseView

@property (nonatomic, weak) id <YD_TwoWaySliderDelegate> delegate;

/// 显示进度的label：在上还是下 ：默认在上面
@property (nonatomic, assign) BOOL isDown;
/// 显示进度的label和滑动原点的间距
@property (nonatomic, assign) CGFloat progressMargin;
/// 显示进度的label的默认文字
@property (nonatomic, copy  ) NSString *progressText;
/// 圆点的图片
@property (nonatomic, copy  ) NSString *thumImageName;

@end

NS_ASSUME_NONNULL_END
