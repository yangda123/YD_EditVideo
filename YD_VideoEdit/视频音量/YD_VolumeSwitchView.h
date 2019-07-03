//
//  YD_VolumeSwitchView.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_VolumeSwitchView : YD_BaseView

@property (nonatomic, weak, readonly) UILabel *titleLbl;
@property (nonatomic, weak, readonly) UISwitch *yd_switch;

@end

NS_ASSUME_NONNULL_END
