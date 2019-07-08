//
//  YD_VolumeSlider.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_VolumeSlider.h"
#import "YD_TwoWaySlider.h"

@interface YD_VolumeSlider () <YD_TwoWaySliderDelegate>

@property (nonatomic, weak) YD_TwoWaySlider *slider;

@property (nonatomic, weak) UILabel *left_label;
@property (nonatomic, weak) UILabel *right_label;

@property (nonatomic, weak) UIView *left_view;
@property (nonatomic, weak) UIView *right_view;

@end

@implementation YD_VolumeSlider

- (instancetype)init {
    self = [super init];
    if (self) {
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
    }
    return self;
}

- (void)yd_layoutSubViews {
    {
        UIView *view = [UIView new];
        self.left_view = view;
        view.layer.borderWidth = 1.0;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [self addSubview:view];
        
        UILabel *label = [UILabel new];
        self.left_label = label;
        label.text = @"0%";
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
    {
        UIView *view = [UIView new];
        self.right_view = view;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [self addSubview:view];
        
        UILabel *label = [UILabel new];
        self.right_label = label;
        label.text = @"200%";
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
    {
        YD_TwoWaySlider *slider = [YD_TwoWaySlider new];
        slider.delegate = self;
        self.slider = slider;
        slider.isDown = YES;
        slider.progressMargin = 6;
        slider.thumImageName = @"yd_slider_3@3x";
        slider.progressText = @"100%";
        [self addSubview:slider];
    }
}

- (void)yd_layoutConstraints {
    [self.left_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(15);
        make.centerY.mas_equalTo(self.slider);
        make.size.mas_equalTo(10);
    }];
    
    [self.right_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(15);
        make.centerY.mas_equalTo(self.slider);
        make.size.mas_equalTo(10);
    }];
    
    [self.left_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(15);
        make.top.equalTo(self.left_view.mas_bottom).inset(10);
    }];
    
    [self.right_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(15);
        make.top.equalTo(self.right_view.mas_bottom).inset(10);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left_view.mas_right);
        make.right.equalTo(self.right_view.mas_left);
        make.top.inset(0);
        make.height.mas_equalTo(twoWaySliderH);
    }];
}

- (void)setThemeColor:(UIColor *)themeColor {
    self.slider.themeColor = themeColor;
    self.left_view.layer.borderColor = themeColor.CGColor;
    self.right_view.backgroundColor = themeColor;
}

#pragma mark - YD_TwoWaySliderDelegate
- (void)sliderValueChange:(YD_TwoWaySlider *)slider value:(CGFloat)value {
    NSInteger newValue = 200 * value;
    self.slider.progressText = [NSString stringWithFormat:@"%ld%@", newValue, @"%"];
}

- (void)sliderDidEndChange:(YD_TwoWaySlider *)slider value:(CGFloat)value {
    if (self.endBlock) {
        self.endBlock(value);
    }
}

@end
