//
//  YD_ClipView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_ClipView.h"
#import "YD_RangeSliderView.h"

@interface YD_ClipView ()

@property (nonatomic, strong) AVAsset *currentAsset;

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UILabel *clipTimeLbl;
@property (nonatomic, weak) UILabel *startTimeLbl;
@property (nonatomic, weak) UILabel *endTimeLbl;

@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) YD_RangeSliderView *sliderView;

@property (nonatomic, assign) NSInteger count;

@end

@implementation YD_ClipView

- (instancetype)initWithAsset:(AVAsset *)asset {
    self = [super init];
    if (self) {
        self.currentAsset = asset;
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
        [self yd_updateImage];
    }
    return self;
}

- (void)yd_layoutSubViews {
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
        label.text = @"总共 0:04.9";
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
    }
    {
        UIView *view = [UIView new];
        self.backView = view;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
    }
    {
        YD_RangeSliderView *sliderView = [YD_RangeSliderView new];
        self.sliderView = sliderView;
        [self addSubview:sliderView];
    }
    {
        UILabel *label = [UILabel new];
        self.startTimeLbl = label;
        label.textAlignment = 1;
        label.text = @"0:00.0";
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
    {
        UILabel *label = [UILabel new];
        self.endTimeLbl = label;
        label.textAlignment = 1;
        label.text = @"0:04.0";
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
    
    for (int i = 0; i < totalCount; i++) {
        UIImageView *imgView = [UIImageView new];
        imgView.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.backView addSubview:imgView];
    }
}

- (void)yd_layoutConstraints {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.left.right.inset(15);
        make.height.mas_equalTo(YD_IPhone7_Width(45));
    }];
    
    [self.backView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [self.backView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.backView);
    }];

    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.height.equalTo(self.backView);
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

- (void)yd_updateImage {
    @weakify(self);
    [self.currentAsset yd_getImagesCount:totalCount imageBackBlock:^(UIImage * _Nonnull image, CMTime actualTime) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.count >= totalCount) { return; }
            UIImage *scaleImg = [UIImage scaleImageWith:image targetWidth:YD_ScreenWidth / 10.0];
            UIImageView *imgView = self.backView.subviews[self.count];
            imgView.image = scaleImg;
            self.count++;
        });
    }];
}

@end
