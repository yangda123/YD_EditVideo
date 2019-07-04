//
//  YD_CompressItem.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_CompressItem : YD_BaseView

@property (nonatomic, weak, readonly) UILabel *rateLbl;
@property (nonatomic, weak, readonly) UILabel *titleLbl;
@property (nonatomic, weak, readonly) UIButton *containBtn;

@end

NS_ASSUME_NONNULL_END
