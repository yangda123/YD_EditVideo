//
//  YD_VolumeSlider.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

typedef void(^YD_EndChangeBlock)(CGFloat value);
NS_ASSUME_NONNULL_BEGIN

@interface YD_VolumeSlider : YD_BaseView

@property (nonatomic, copy) YD_EndChangeBlock endBlock;

@end

NS_ASSUME_NONNULL_END
