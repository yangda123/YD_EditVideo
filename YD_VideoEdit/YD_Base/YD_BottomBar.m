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

+ (instancetype)addBar:(NSString *)title
               imgName:(NSString *)imgName {
    YD_BottomBar *bar = [[YD_BottomBar alloc] initTitle:title imgName:imgName];
    return bar;
}

- (instancetype)initTitle:(NSString *)title imgName:(NSString *)name {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self yd_layoutSubView:title imgName:name];
    }
    return self;
}

- (void)yd_layoutSubView:(NSString *)title imgName:(NSString *)name {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = NO;
    button.frame = CGRectMake(0, 0, YD_ScreenWidth, YD_BottomBarH - YD_BottomBangsH);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self addSubview:button];
    
    [button layoutButtonWithEdgeInsetsStyle:0 imageTitleSpace:8];
}

@end
