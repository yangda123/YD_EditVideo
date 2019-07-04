//
//  YD_CompressItem.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_CompressItem.h"

@interface YD_CompressItem ()

@property (nonatomic, weak) UILabel *rateLbl;
@property (nonatomic, weak) UILabel *rateTitleLbl;
@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UIButton *containBtn;

@end

@implementation YD_CompressItem

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
        UIButton *button = [UIButton new];
        self.containBtn = button;
        button.adjustsImageWhenHighlighted = NO;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [self addSubview:button];
    }
    {
        UILabel *label = [UILabel new];
        self.rateLbl = label;
        label.textAlignment = 1;
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:18];
        [self.containBtn addSubview:label];
    }
    {
        UILabel *label = [UILabel new];
        self.rateTitleLbl = label;
        label.text = @"(压缩率)";
        label.textColor = UIColor.whiteColor;
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:10];
        [self.containBtn addSubview:label];
    }
    {
        UILabel *label = [UILabel new];
        self.titleLbl = label;
        label.textColor = UIColor.blackColor;
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
    }
}

- (void)yd_layoutConstraints {
    [self.containBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.inset(0);
        make.height.mas_equalTo(self.containBtn.mas_width);
    }];
    
    [self.rateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.bottom.equalTo(self.containBtn.mas_centerY).offset(4);
    }];
    
    [self.rateTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.rateLbl.mas_bottom);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.inset(0);
        make.top.equalTo(self.containBtn.mas_bottom).inset(6);
    }];
}

#pragma mark - setter
- (void)setThemeColor:(UIColor *)themeColor {
    [self.containBtn setImage:[UIImage imageWithColor:[themeColor colorWithAlphaComponent:0.4] size:CGSizeMake(50, 50)] forState:UIControlStateNormal];
    [self.containBtn setImage:[UIImage imageWithColor:themeColor size:CGSizeMake(50, 50)] forState:UIControlStateSelected];
}

@end
