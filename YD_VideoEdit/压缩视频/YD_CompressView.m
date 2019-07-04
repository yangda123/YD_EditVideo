//
//  YD_CompressView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_CompressView.h"
#import "YD_CompressItem.h"

@interface YD_CompressView ()

@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UILabel *contentLbl;
@property (nonatomic, weak) UIButton *selectBtn;

@property (nonatomic, copy) NSArray *itemArr;
@property (nonatomic, copy) NSArray *rateArr;

@end

@implementation YD_CompressView

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
        UILabel *label = [UILabel new];
        self.titleLbl = label;
        label.text = @"选择视频压缩的质量";
        label.textColor = UIColor.blackColor;
        label.textAlignment = 1;
        label.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:label];
    }
    {
        UILabel *label = [UILabel new];
        self.contentLbl = label;
        label.textColor = UIColor.blackColor;
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
    }
    {
        NSArray *titles = @[@"质量高", @"质量中", @"质量低"];
        self.rateArr = @[@(25), @(50), @(75)];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < titles.count; i++) {
            YD_CompressItem *item = [YD_CompressItem new];
            item.rateLbl.text = [NSString stringWithFormat:@"%@%@", self.rateArr[i], @"%"];
            item.titleLbl.text = titles[i];
            item.containBtn.tag = i;
            [item.containBtn addTarget:self action:@selector(yd_itemAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
            [arr addObject:item];
            
            if (i == 0) {
                item.containBtn.selected = YES;
                self.selectBtn = item.containBtn;
            }
        }
        self.itemArr = arr.copy;
    }
}

- (void)yd_layoutConstraints {
     [self.itemArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:45 leadSpacing:50 tailSpacing:50];
    [self.itemArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).inset(YD_IPhone7_Width(3));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.equalTo(self.contentLbl.mas_top).inset(YD_IPhone7_Width(9));
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.equalTo(self.mas_centerY).inset(YD_IPhone7_Width(18));
    }];
}

#pragma mark - setter
- (void)setThemeColor:(UIColor *)themeColor {
    for (int i = 0; i < self.itemArr.count; i++) {
        YD_CompressItem *item = self.itemArr[i];
        item.themeColor = themeColor;
    }
}

- (void)setFileSize:(CGFloat)fileSize {
    self.contentLbl.text = [NSString stringWithFormat:@"当前视频%.2fMB", fileSize];
}

#pragma mark - UI事件
- (void)yd_itemAction:(UIButton *)button {
    if (button == self.selectBtn) { return; }
    
    button.selected = YES;
    self.selectBtn.selected = NO;
    self.selectBtn = button;
}

- (NSString *)yd_assetExportPreset {
    if (self.selectBtn.tag == 0) {
        return AVAssetExportPresetHighestQuality;
    }else if (self.selectBtn.tag == 1) {
        return AVAssetExportPresetMediumQuality;
    }
    return AVAssetExportPresetLowQuality;
}

@end
