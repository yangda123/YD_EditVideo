//
//  YD_ClipView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

typedef void(^ClipCompleteBlock)(CGFloat start, CGFloat end);

NS_ASSUME_NONNULL_BEGIN

@interface YD_ClipView : YD_BaseView

- (instancetype)initWithAsset:(AVAsset *)asset;

@property (nonatomic, copy) ClipCompleteBlock completeBlock;

@end

NS_ASSUME_NONNULL_END
