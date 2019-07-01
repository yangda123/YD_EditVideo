//
//  UIButton+YD_Extension.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YD_ButtonEdgeInsetsStyle) {
    YD_ButtonEdgeInsetsStyleTop, // image在上，label在下
    YD_ButtonEdgeInsetsStyleLeft, // image在左，label在右
    YD_ButtonEdgeInsetsStyleBottom, // image在下，label在上
    YD_ButtonEdgeInsetsStyleRight // image在右，label在左
};

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YD_Extension)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(YD_ButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
