//
//  YD_PlayerFilterCell.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YD_PlayerFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_PlayerFilterCell : UICollectionViewCell

+ (CGSize)yd_cellSize;

@property (nonatomic, strong) YD_PlayerFilterModel *model;

@end

NS_ASSUME_NONNULL_END
