//
//  YD_TwoWaySlider.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_TwoWaySlider.h"

@interface YD_TwoWaySlider ()

@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIView *progressLine;
@property (nonatomic, weak) UIView *centerView;

@property (nonatomic, weak) UIButton *pointBtn;
@property (nonatomic, weak) UILabel *progressLbl;

@end

@implementation YD_TwoWaySlider

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isDown = NO;
        self.progressMargin = 1;
        [self yd_layoutSubViews];
    }
    return self;
}

- (void)yd_layoutSubViews {
    {
        UIView *view = [UIView new];
        self.lineView = view;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 1;
        view.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        [self addSubview:view];
    }
    {
        UIView *view = [UIView new];
        self.progressLine = view;
        [self addSubview:view];
    }
    {
        UIView *view = [UIView new];
        self.centerView = view;
        view.backgroundColor = UIColor.whiteColor;
        [self addSubview:view];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pointBtn = button;
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage yd_imageWithName:@"yd_slider_1@3x"] forState:UIControlStateNormal];
        [self addSubview:button];
        
        [button addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGesture:)]];
    }
    {
        UILabel *label = [UILabel new];
        self.progressLbl = label;
        label.text = @"1.0x";
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
}

- (void)layoutSubviews {
    
    if (self.pointBtn.YD_width != 0) { return; }
    
    CGFloat width = self.YD_width;
    CGFloat height = self.YD_height;
    
    CGFloat pointH = MIN(height, 44);
    
    self.lineView.frame = CGRectMake(pointH * 0.5, height * 0.5 - 1, width - pointH, 2);
    self.progressLine.frame = CGRectMake(0, height * 0.5 - 1, 0, 2);
    self.centerView.frame = CGRectMake(width * 0.5 - 1.5, height * 0.5 - 2.5, 3, 5);
    
    self.pointBtn.frame = CGRectMake(width * 0.5 - pointH * 0.5, height * 0.5 - pointH * 0.5, pointH, pointH);
    
    self.progressLbl.frame = CGRectMake(0, 0, 80, 15);
    self.progressLbl.YD_centerX = self.pointBtn.YD_centerX;
    if (self.isDown) {
        self.progressLbl.YD_bottom = self.pointBtn.YD_bottom + self.progressMargin;
    }else {
        self.progressLbl.YD_x = self.pointBtn.YD_y - self.progressMargin;
    }
}

#pragma mark - setter
- (void)setThemeColor:(UIColor *)themeColor {
    self.progressLine.backgroundColor = themeColor;
    self.progressLbl.textColor = themeColor;
}

- (void)setProgressText:(NSString *)progressText {
    self.progressLbl.text = progressText;
}

- (void)setThumImageName:(NSString *)thumImageName {
    [self.pointBtn setImage:[UIImage yd_imageWithName:thumImageName] forState:UIControlStateNormal];
}

#pragma mark - UI事件
- (void)dragGesture:(UIPanGestureRecognizer *)gesture {
    
    CGFloat margin = self.pointBtn.YD_width * 0.5;
    
    CGPoint translation = [gesture translationInView:self];
    CGFloat center_x = self.pointBtn.YD_centerX;
    center_x += translation.x;
    center_x = MIN(center_x, self.YD_width - margin);
    center_x = MAX(center_x, margin);
    [gesture setTranslation:CGPointZero inView:self];

    self.pointBtn.YD_centerX = center_x;
    self.progressLbl.YD_centerX = center_x;
    
    CGFloat width = self.YD_width * 0.5;
    CGFloat line_width = fabs(center_x - width);
    CGFloat line_x = center_x > width ? width : width - line_width;
    
    self.progressLine.YD_x = line_x;
    self.progressLine.YD_width = line_width;
    
    CGFloat value = (center_x - margin) / (self.YD_width - self.pointBtn.YD_width);
    NSInteger newValue = value * 100;

    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(sliderValueChange:value:)]) {
            [self.delegate sliderValueChange:self value:newValue / 100.0];
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateFailed) {
        if ([self.delegate respondsToSelector:@selector(sliderDidEndChange:value:)]) {
            [self.delegate sliderDidEndChange:self value:newValue / 100.0];
        }
    }
}

@end
