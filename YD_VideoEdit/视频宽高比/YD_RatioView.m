//
//  YD_RatioView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_RatioView.h"

@interface YD_RatioView ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *ratioArr;
@property (nonatomic, strong) NSMutableArray *viewArr;

@property (nonatomic, assign) CGFloat originRatio;

@property (nonatomic, weak) YD_CustomView *customView;

@end

@implementation YD_RatioView

- (instancetype)initWithRatio:(CGFloat)ratio {
    self = [super init];
    if (self) {
        self.originRatio = ratio;
        self.viewArr = [NSMutableArray arrayWithCapacity:0];
        
        [self yd_setupData];
        [self yd_layoutSubViews];
    }
    return self;
}

- (void)yd_setupData {
    self.titleArr = @[@"原图", @"1:1", @"2:3", @"3:2"];
    self.ratioArr = @[@(self.originRatio), @(1), @(2.0/3.0), @(3.0/2.0)];
}

- (void)yd_layoutSubViews {
    UIScrollView *scrollView = [UIScrollView new];
    self.scrollView = scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    for (int i = 0; i < self.titleArr.count; i++) {
        YD_CustomView *view = [[YD_CustomView alloc] initWithRatio:[self.ratioArr[i] doubleValue] title:self.titleArr[i]];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yd_tagGesture:)]];
        [scrollView addSubview:view];
        [self.viewArr addObject:view];
        
        if (i == 0) {
            self.customView = view;
            self.customView.selectView.hidden = NO;
        }else {
            view.selectView.hidden = YES;
        }
    }
}

- (void)layoutSubviews {
    CGFloat last_x = 20;
    CGFloat margin = 20;
    CGFloat view_w = (self.YD_width - margin * 5) / 4;
    CGFloat view_h = view_w + 25;

    for (int i = 0; i < self.viewArr.count; i++) {
        YD_CustomView *view = self.viewArr[i];
        view.selectView.layer.borderColor = self.themeColor.CGColor;
        view.frame = CGRectMake(last_x, self.YD_height * 0.5 - view_h * 0.5, view_w , view_h);
        last_x = view.YD_right + 20;
    }
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(last_x, self.YD_height);
}

#pragma mark - UI事件
- (void)yd_tagGesture:(UITapGestureRecognizer *)tapGesture {
    YD_CustomView *view = (YD_CustomView *)tapGesture.view;
    if (view == self.customView) {
        return;
    }
    
    self.customView.selectView.hidden = YES;
    view.selectView.hidden = NO;
    self.customView = view;
    
    if (self.ratioBlock) {
        self.ratioBlock(view.ratio);
    }
}

@end

@interface YD_CustomView ()

@property (nonatomic, weak) UIView *borderView;
@property (nonatomic, weak) UILabel *ratioLabel;
@property (nonatomic, weak) UIView *selectView;

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, assign) CGFloat ratio;

@end

@implementation YD_CustomView

- (instancetype)initWithRatio:(CGFloat)ratio title:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
        self.ratio = ratio;
        [self yd_layoutSubViews];
    }
    return self;
}

- (void)yd_layoutSubViews {
    {
        UIView *view = [UIView new];
        self.borderView = view;
        [self addSubview:view];
        
        view.layer.borderColor = UIColor.blackColor.CGColor;
        view.layer.borderWidth = 1.5;
    }
    {
        UIView *view = [UIView new];
        self.selectView = view;
        view.layer.borderWidth = 1.5;
        [self addSubview:view];
    }
    {
        UILabel *label = [UILabel new];
        self.ratioLabel = label;
        label.textAlignment = 1;
        label.text = self.title;
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
    }
}

- (void)layoutSubviews {
    CGFloat margin = 8;
    CGFloat width = self.YD_width - margin * 2;
    
    CGFloat ratio = self.ratio;
    if ([self.title isEqualToString:@"原图"]) {
        ratio = 1.0;
    }
    
    CGFloat border_w = ratio > 1 ? width : width * ratio;
    CGFloat border_h = ratio < 1 ? width : width / ratio;
    
    self.borderView.frame = CGRectMake(margin + width * 0.5 - border_w * 0.5, margin + width * 0.5 - border_h * 0.5, border_w, border_h);
    self.selectView.frame = CGRectMake(0, 0, self.YD_width, self.YD_width);
    self.ratioLabel.frame = CGRectMake(0, self.YD_height - 20, self.YD_width, 20);
}

@end
