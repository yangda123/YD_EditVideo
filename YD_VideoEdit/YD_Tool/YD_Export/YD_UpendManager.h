//
//  YD_UpendManager.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/5.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YD_VideoEditManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_UpendManager : NSObject

+ (void)yd_upendAsset:(AVAsset *)asset finish:(YD_ExportFinishBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
