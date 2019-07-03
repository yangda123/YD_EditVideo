//
//  YD_BottomBar.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BottomBar.h"

@interface YD_BottomBar ()

@end

@implementation YD_BottomBar

+ (instancetype)addBar:(NSString *)title image:(UIImage *)image {
    YD_BottomBar *bar = [[YD_BottomBar alloc] initTitle:title image:image];
    return bar;
}

- (instancetype)initTitle:(NSString *)title image:(UIImage *)image {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self yd_layoutSubView:title image:image];
    }
    return self;
}

- (void)yd_layoutSubView:(NSString *)title image:(UIImage *)image {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = NO;
    button.frame = CGRectMake(0, 0, YD_ScreenWidth, YD_BottomBarH - YD_BottomBangsH);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button setImage:image forState:UIControlStateNormal];
    [self addSubview:button];
    
    [button layoutButtonWithEdgeInsetsStyle:0 imageTitleSpace:8];
}

@end
