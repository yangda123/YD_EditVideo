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

typedef void(^YD_CopyBlock)(NSArray *modelArr, BOOL flag);
@interface YD_CopyView : YD_BaseView

- (instancetype)initWithModel:(YD_PlayerModel *)model;

@property (nonatomic, strong, readonly) NSMutableArray *modelArray;

@property (nonatomic, copy) YD_CopyBlock copyBlock;

@end

NS_ASSUME_NONNULL_END
