//
//  YD_BasePlayControlView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"
#import "YD_PlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_BasePlayControlView : YD_BaseView <YD_PlayerViewDelegate>

@property (nonatomic, weak) YD_PlayerView *player;

@end

NS_ASSUME_NONNULL_END
