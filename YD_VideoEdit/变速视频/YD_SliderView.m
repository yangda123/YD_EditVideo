//
//  YD_SliderView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_SliderView.h"

@interface YD_SliderView ()

@property (nonatomic, weak) UIView *containView;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIView *centerView;


@property (nonatomic, weak) UIButton *pointBtn;
@property (nonatomic, weak) UILabel *progressLbl;
@property (nonatomic, weak) UIView *progressView;

@property (nonatomic, weak) UILabel *leftLbl;
@property (nonatomic, weak) UILabel *rightLbl;

@end

@implementation YD_SliderView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentSpeed = 1.0;
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
    }
    return self;
}

- (void)yd_layoutSubViews {
    {
        UIView *view = [UIView new];
        self.containView = view;
        [self addSubview:view];
    }
    {
        UIView *view = [UIView new];
        self.lineView = view;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 1;
        view.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        [self.containView addSubview:view];
    }
    {
        UIView *view = [UIView new];
        self.progressView = view;
        [self.containView addSubview:view];
    }
    {
        UIView *view = [UIView new];
        self.centerView = view;
        view.backgroundColor = UIColor.whiteColor;
        [self.containView addSubview:view];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pointBtn = button;
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage yd_imageWithName:@"yd_slider_1@3x"] forState:UIControlStateNormal];
        [self.containView addSubview:button];
        
        [button addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGesture:)]];
    }
    
    {
        UILabel *label = [UILabel new];
        self.progressLbl = label;
        label.text = @"1.0x";
        label.font = [UIFont systemFontOfSize:10];
        [self.containView addSubview:label];
    }
    {
        UILabel *label = [UILabel new];
        self.leftLbl = label;
        label.text = @"0.2x";
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
    {
        UILabel *label = [UILabel new];
        self.rightLbl = label;
        label.text = @"4.0x";
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
}

- (void)yd_layoutConstraints {
    
    CGFloat height = 50;
    CGFloat width = YD_ScreenWidth - 120;
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(60);
        make.bottom.top.inset(0);
        make.height.mas_equalTo(height);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.centerY.equalTo(self.containView);
        make.height.mas_equalTo(2);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(width * 0.5);
        make.left.offset(width * 0.5);
        make.centerY.equalTo(self.containView);
        make.height.mas_equalTo(2);
    }];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.lineView);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(5);
    }];
    
    [self.progressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pointBtn);
        make.top.inset(3);
    }];
    
    [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.inset(25);
        make.centerY.equalTo(self.pointBtn);
    }];
    
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.inset(25);
        make.centerY.equalTo(self.pointBtn);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pointBtn.frame = CGRectMake(0, 0, 50, height);
        self.pointBtn.YD_centerX = self.containView.YD_width * 0.5;
    });
}

- (void)setThemeColor:(UIColor *)themeColor {
    self.progressView.backgroundColor = themeColor;
    self.progressLbl.textColor = themeColor;
}

#pragma mark - UI事件
- (void)dragGesture:(UIPanGestureRecognizer *)gesture {
    
    CGPoint translation = [gesture translationInView:self.containView];
    CGFloat center_x = self.pointBtn.YD_centerX;
    center_x += translation.x;
    center_x = MIN(center_x, self.containView.YD_width);
    center_x = MAX(center_x, 0);
    [gesture setTranslation:CGPointZero inView:self.containView];
    
    self.pointBtn.YD_centerX = center_x;
    
    CGFloat width = self.containView.YD_width * 0.5;
    CGFloat left = MIN(width, center_x);
    CGFloat right = MIN(width, self.containView.YD_width - center_x);
    
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(left);
        make.right.inset(right);
    }];
    
    CGFloat value = 0;
    NSInteger newValue = 0;
    
    if (center_x <= width) {
        value = (width - center_x) / width;
        newValue = 100 - 80 * value;
    }else {
        value = (center_x - width) / width;
        newValue = 300 * value + 100;
    }
    
    self.progressLbl.text = [NSString stringWithFormat:@"%.1f", newValue / 100.0];
    
    self.currentSpeed = self.progressLbl.text.doubleValue;
    
    if ([self.delegate respondsToSelector:@selector(speedChange:speed:)]) {
        [self.delegate speedChange:self speed:self.currentSpeed];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateFailed) {
        if ([self.delegate respondsToSelector:@selector(speedDidChange:speed:)]) {
            [self.delegate speedDidChange:self speed:self.currentSpeed];
        }
    }
}

@end
