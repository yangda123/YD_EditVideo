//
//  YD_CompressView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_CompressView : YD_BaseView

- (NSString *)yd_assetExportPreset;

@property (nonatomic, assign) CGFloat fileSize;

@end

NS_ASSUME_NONNULL_END
