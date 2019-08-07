//
//  YD_FilterCollectionCell.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YD_FilterModel.h"
#import "UIImage+YD_Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_FilterCollectionCell : UICollectionViewCell

+ (CGSize)yd_cellSize;

@property (nonatomic, strong) YD_FilterModel *model;

@end

NS_ASSUME_NONNULL_END
