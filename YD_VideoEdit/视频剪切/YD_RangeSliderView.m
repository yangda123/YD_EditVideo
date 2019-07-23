//
//  YD_RangeSliderView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_RangeSliderView.h"

static CGFloat drag_margin = 10.0;

@interface YD_RangeSliderView ()

@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;

/// 左边时间拖拽view
@property (nonatomic, weak) UIButton *leftDragView;
/// 右边时间拖拽view
@property (nonatomic, weak) UIButton *rightDragView;

@property (nonatomic, weak) UIView *backImgView;
@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *rigthView;

@property (nonatomic, strong) AVAsset *currentAsset;
@property (nonatomic, assign) NSInteger count;

@end

@implementation YD_RangeSliderView

- (instancetype)initWithAsset:(AVAsset *)asset {
    self = [super init];
    if (self) {
        self.currentAsset = asset;
        self.totalTime = [asset yd_getSeconds];
        self.startTime = 0;
        self.endTime = self.totalTime;
        
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
        [self yd_updateImage];
    }
    return self;
}

- (void)yd_layoutSubViews {
    {
        UIView *view = [UIView new];
        self.backImgView = view;
        [self addSubview:view];
    }
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
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage yd_imageWithName:@"yd_leftSlider@3x"] forState:UIControlStateNormal];
        self.leftDragView = button;
        button.backgroundColor = UIColor.whiteColor;
        [button addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftDragGesture:)]];
        [self addSubview:button];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage yd_imageWithName:@"yd_rightSlider@3x"] forState:UIControlStateNormal];
        self.rightDragView = button;
        button.backgroundColor = UIColor.whiteColor;
        [button addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightDragGesture:)]];
        [self addSubview:button];
    }
    for (int i = 0; i < totalCount; i++) {
        UIImageView *imgView = [UIImageView new];
        imgView.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.backImgView addSubview:imgView];
    }
}

- (void)yd_layoutConstraints {
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.bottom.inset(3);
    }];
    
    [self.backImgView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.backImgView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.backImgView);
    }];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.inset(3);
        make.left.inset(0);
        make.right.equalTo(self.leftDragView.mas_left);
    }];
    
    [self.rigthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.inset(3);
        make.right.inset(0);
        make.left.equalTo(self.rightDragView.mas_right);
    }];
    
    [self.leftDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.inset(0);
        make.width.mas_equalTo(22);
    }];
    
    [self.rightDragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.inset(0);
        make.width.mas_equalTo(24);
    }];
}

- (void)yd_updateImage {
    @weakify(self);
    [self.currentAsset yd_getImagesCount:totalCount imageBackBlock:^(UIImage * _Nonnull image, CMTime actualTime) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.count >= totalCount) { return; }
            UIImage *scaleImg = [UIImage scaleImageWith:image targetWidth:YD_ScreenWidth / 10.0];
            UIImageView *imgView = self.backImgView.subviews[self.count];
            imgView.image = scaleImg;
            self.count++;
        });
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
    
    CGFloat progress = left / self.YD_width;
    progress = MAX(0, progress);
    self.startTime = progress * self.totalTime;
    
    if ([self.delegate respondsToSelector:@selector(leftValueChange:time:)]) {
        [self.delegate leftValueChange:self time:self.startTime];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateFailed) {
        if ([self.delegate respondsToSelector:@selector(leftDidEndChange:time:)]) {
            [self.delegate leftDidEndChange:self time:self.startTime];
        }
    }
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
    
    CGFloat progress = right / self.YD_width;
    progress = MAX(0, progress);
    self.endTime = progress * self.totalTime;
    
    if ([self.delegate respondsToSelector:@selector(rightValueChange:time:)]) {
        [self.delegate rightValueChange:self time:self.endTime];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateFailed) {
        if ([self.delegate respondsToSelector:@selector(rightDidEndChange:time:)]) {
            [self.delegate rightDidEndChange:self time:self.endTime];
        }
    }
}

@end
