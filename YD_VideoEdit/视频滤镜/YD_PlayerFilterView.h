//
//  YD_PlayerFilterView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

typedef void(^FilterBlock)(NSString * _Nonnull filterName);

NS_ASSUME_NONNULL_BEGIN

@interface YD_PlayerFilterView : YD_BaseView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy  ) FilterBlock filterBlock;

@end

NS_ASSUME_NONNULL_END
