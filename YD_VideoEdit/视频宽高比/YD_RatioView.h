//
//  YD_RatioView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

@class YD_CustomView;

NS_ASSUME_NONNULL_BEGIN

@interface YD_RatioView : YD_BaseView

- (instancetype)initWithRatio:(CGFloat)ratio;

@end

NS_ASSUME_NONNULL_END


@interface YD_CustomView : YD_BaseView

- (instancetype _Nonnull)initWithRatio:(CGFloat)ratio title:(NSString *_Nullable)title;

@property (nonatomic, weak, readonly) UIView *selectView;

@end
