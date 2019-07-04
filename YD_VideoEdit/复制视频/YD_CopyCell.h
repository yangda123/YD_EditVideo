//
//  YD_CopyCell.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YD_PlayerView.h"

@class YD_CopyCell;

typedef void(^YD_DeleteBlock)(YD_CopyCell *_Nonnull copyCell);
NS_ASSUME_NONNULL_BEGIN

@interface YD_CopyCell : UICollectionViewCell

+ (CGSize)yd_cellSize;

@property (nonatomic, copy) YD_DeleteBlock deleteBlock;

- (void)playModel:(YD_PlayerModel *)model row:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
