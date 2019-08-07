//
//  YD_FilterCollectionView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"
#import <GPUImage.h>

typedef void(^FilterNameBlock)(GPUImageOutput<GPUImageInput> * _Nonnull imgOutput);
NS_ASSUME_NONNULL_BEGIN

@interface YD_FilterCollectionView : YD_BaseView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy  ) FilterNameBlock filterBlock;

@end

NS_ASSUME_NONNULL_END
