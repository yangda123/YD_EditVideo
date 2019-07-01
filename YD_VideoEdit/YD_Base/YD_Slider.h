//
//  YD_Slider.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YD_Slider : UISlider
/// 例：left_offset = 5 圆点位置向左偏移5 
@property (nonatomic, assign) CGFloat left_offset;
@property (nonatomic, assign) CGFloat right_offset;

@end

NS_ASSUME_NONNULL_END
