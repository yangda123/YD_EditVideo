//
//  YD_DefaultPlayControlView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BasePlayControlView.h"

typedef void(^YD_PlayBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface YD_DefaultPlayControlView : YD_BasePlayControlView

@property (nonatomic, copy) YD_PlayBlock playBlock;

@end

NS_ASSUME_NONNULL_END
