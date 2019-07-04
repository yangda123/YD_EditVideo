//
//  YD_CopyView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"
#import "YD_PlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_CopyView : YD_BaseView

- (instancetype)initWithModel:(YD_PlayerModel *)model;

@property (nonatomic, strong, readonly) NSMutableArray *modelArray;

@end

NS_ASSUME_NONNULL_END
