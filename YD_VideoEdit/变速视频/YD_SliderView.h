//
//  YD_SliderView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

@class YD_SliderView;

@protocol YD_SliderViewwDelegate <NSObject>

@optional
- (void)speedChange:(YD_SliderView *_Nonnull)slider speed:(CGFloat)speed;
- (void)speedDidChange:(YD_SliderView *_Nonnull)slider speed:(CGFloat)speed;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YD_SliderView : YD_BaseView

@property (nonatomic, assign) CGFloat currentSpeed;

@property (nonatomic, weak) id <YD_SliderViewwDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
