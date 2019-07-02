//
//  YD_RatioView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

@class YD_CustomView;

typedef void(^YD_RatioBlock)(CGFloat ratio);

NS_ASSUME_NONNULL_BEGIN

@interface YD_RatioView : YD_BaseView

- (instancetype)initWithRatio:(CGFloat)ratio;

@property (nonatomic, copy) YD_RatioBlock ratioBlock;

@end

NS_ASSUME_NONNULL_END


@interface YD_CustomView : YD_BaseView

- (instancetype _Nonnull)initWithRatio:(CGFloat)ratio title:(NSString *_Nullable)title;

@property (nonatomic, weak, readonly, nullable) UIView *selectView;
@property (nonatomic, assign, readonly) CGFloat ratio;

@end
