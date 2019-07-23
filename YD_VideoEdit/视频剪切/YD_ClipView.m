//
//  YD_ClipView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_ClipView.h"
#import "YD_RangeSliderView.h"

@interface YD_ClipView () <YD_RangeSliderViewDelegate>

@property (nonatomic, strong) AVAsset *currentAsset;

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UILabel *clipTimeLbl;
@property (nonatomic, weak) UILabel *startTimeLbl;
@property (nonatomic, weak) UILabel *endTimeLbl;

@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;

@property (nonatomic, weak) YD_RangeSliderView *sliderView;

@property (nonatomic, assign) NSInteger count;

@end

@implementation YD_ClipView

- (instancetype)initWithAsset:(AVAsset *)asset {
    self = [super init];
    if (self) {
        self.currentAsset = asset;
        self.startTime = 0;
        self.endTime = [asset yd_getSeconds];
        
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
    }
    return self;
}

- (void)yd_layoutSubViews {
    NSString *totalTime = [NSString timeToString:self.endTime format:@"%02zd:%02zd"];
    {
        UILabel *label = [UILabel new];
        self.titleLbl = label;
        label.textAlignment = 1;
        label.text = @"选择导出片段";
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:label];
    }
    {
        UILabel *label = [UILabel new];
        self.clipTimeLbl = label;
        label.textAlignment = 1;
        label.text = [NSString stringWithFormat:@"总共 %@", totalTime];
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
    }
    {
        YD_RangeSliderView *sliderView = [[YD_RangeSliderView alloc] initWithAsset:self.currentAsset];
        self.sliderView = sliderView;
        sliderView.delegate = self;
        [self addSubview:sliderView];
    }
    {
        UILabel *label = [UILabel new];
        self.startTimeLbl = label;
        label.textAlignment = 1;
        label.text = @"00:00";
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
    {
        UILabel *label = [UILabel new];
        self.endTimeLbl = label;
        label.textAlignment = 1;
        label.text = totalTime;
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
}

- (void)yd_layoutConstraints {
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(-5);
        make.left.right.inset(15);
        make.height.mas_equalTo(YD_IPhone7_Width(50));
    }];
    
    [self.clipTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sliderView.mas_top).inset(YD_IPhone7_Width(18));
        make.left.right.inset(15);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.clipTimeLbl.mas_top).inset(YD_IPhone7_Width(18));
        make.left.right.inset(15);
    }];
    
    [self.startTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderView.mas_bottom).inset(YD_IPhone7_Width(16));
        make.left.inset(15);
    }];
    
    [self.endTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderView.mas_bottom).inset(YD_IPhone7_Width(16));
        make.right.inset(15);
    }];
}

#pragma mark - YD_RangeSliderViewDelegate
- (void)leftValueChange:(YD_RangeSliderView *_Nonnull)sliderView
                   time:(CGFloat)startTime {
    self.startTime = startTime;
    NSString *time = [NSString timeToString:startTime format:@"%02zd:%02zd"];
    self.startTimeLbl.text = time;
}

- (void)rightValueChange:(YD_RangeSliderView *_Nonnull)sliderView
                    time:(CGFloat)endTime {
    self.endTime = endTime;
    NSString *time = [NSString timeToString:endTime format:@"%02zd:%02zd"];
    self.endTimeLbl.text = time;
}

- (void)leftDidEndChange:(YD_RangeSliderView *_Nonnull)sliderView
                    time:(CGFloat)startTime {
    self.startTime = startTime;
    if (self.completeBlock) {
        self.completeBlock(self.startTime, self.endTime);
    }
}

- (void)rightDidEndChange:(YD_RangeSliderView *_Nonnull)sliderView
                     time:(CGFloat)endTime {
    self.endTime = endTime;
    if (self.completeBlock) {
        self.completeBlock(self.startTime, self.endTime);
    }
}

@end
