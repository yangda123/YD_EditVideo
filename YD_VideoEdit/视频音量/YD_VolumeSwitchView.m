//
//  YD_VolumeSwitchView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_VolumeSwitchView.h"

@interface YD_VolumeSwitchView ()

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UISwitch *yd_switch;

@end

@implementation YD_VolumeSwitchView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
    }
    return self;
}

- (void)yd_layoutSubViews {
    self.backgroundColor = RGB(210, 210, 210);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    {
        UILabel *label = [UILabel new];
        self.titleLbl = label;
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
    }
    {
        CGFloat scale = MIN(YD_IPhone7_Width(0.7), 0.8);
        UISwitch *sw = [UISwitch new];
        self.yd_switch = sw;
        sw.transform = CGAffineTransformMakeScale(scale, scale);
        [self addSubview:sw];
    }
}

- (void)yd_layoutConstraints {
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(12);
        make.top.bottom.inset(0);
    }];
    
    [self.yd_switch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(12);
        make.centerY.equalTo(self);
    }];
}

@end
