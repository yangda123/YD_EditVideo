//
//  YD_FilterModel.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface YD_FilterModel : NSObject

@property (nonatomic, strong) GPUImageOutput <GPUImageInput>*imgOutput;//滤镜
@property (nonatomic, strong) UIImage *filterImage;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
