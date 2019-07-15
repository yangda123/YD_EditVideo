//
//  YD_RangeSliderView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_RangeSliderView.h"

#define YD_DragRatio (54.0 / 116.0)

static CGFloat drag_margin = 20.0;

@interface YD_RangeSliderView ()

/// 左边时间拖拽view
@property (nonatomic, weak) UIImageView *leftDragView;
/// 右边时间拖拽view
@property (nonatomic, weak) UIImageView *rightDragView;

@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *rigthView;

@end

@implementation YD_RangeSliderView

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
        self.leftView = view;
        view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
        [self addSubview:view];
    }
    {
        UIView *view = [UIView new];
        self.rigthView = view;
        view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
        [self addSubview:view];
    }
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"左进度"]];
        self.leftDragView = imgView;
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftDragGesture:)]];
        [self addSubview:imgView];
    }
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右进度"]];
        self.rightDragView = imgView;
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightDragGesture:)]];
        [self addSubview:imgView];
    }
}

- (void)yd_layoutConstraints {
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.inset(0);
        make.right.equalTo(self.leftDragView.mas_left);
    }];
    
    [self.rigthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.inset(0);
        make.left.equalTo(self.rightDragView.mas_right);
    }];
    
    [self.leftDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.inset(0);
        make.left.inset(0);
        make.width.equalTo(self.leftDragView.mas_height).multipliedBy(YD_DragRatio);
    }];
    
    [self.rightDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.inset(0);
        make.width.equalTo(self.leftDragView.mas_height).multipliedBy(YD_DragRatio);
    }];
}

#pragma mark - UI事件
- (void)leftDragGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    
    CGFloat left = self.leftDragView.YD_x;
    
    left += translation.x;
    if (left < 0) {
        left = 0;
    }
    
    CGFloat left_max_x = self.rightDragView.YD_x - self.leftDragView.YD_width - drag_margin;
    
    if (left > left_max_x) {
        left = left_max_x;
    }
    
    [gesture setTranslation:CGPointZero inView:self];
    
    [self.leftDragView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
    }];
    
}

- (void)rightDragGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    CGFloat right = self.rightDragView.YD_right;
    
    right += translation.x;
    if (right > self.YD_width){
        right = self.YD_width;
    }
    
    CGFloat right_min_x = self.leftDragView.YD_right + self.rightDragView.YD_width + drag_margin;
    if (right < right_min_x){
        right = right_min_x;
    }
    
    [gesture setTranslation:CGPointZero inView:self];
    
    [self.rightDragView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.inset(self.YD_width - right);
    }];
   
}

@end
