//
//  YD_RangeSliderView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

static NSInteger totalCount = 10;

NS_ASSUME_NONNULL_BEGIN

@interface YD_RangeSliderView : YD_BaseView

@property (nonatomic, assign, readonly) CGFloat totalTime;
@property (nonatomic, assign, readonly) CGFloat startTime;
@property (nonatomic, assign, readonly) CGFloat endTime;

@end

NS_ASSUME_NONNULL_END
