//
//  YD_FilterCollectionCell.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_FilterCollectionCell.h"
#import <Masonry.h>

@interface YD_FilterCollectionCell ()

@property (nonatomic, weak) UIImageView *imgView;

@end

@implementation YD_FilterCollectionCell

+ (CGSize)yd_cellSize {
    return CGSizeMake(78, 78);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
    }
    return self;
}

- (void)yd_layoutSubViews {
    self.contentView.backgroundColor = UIColor.clearColor;
    {
        UIImageView *imgView = [UIImageView new];
        self.imgView = imgView;
        imgView.layer.cornerRadius = 8.0;
        imgView.layer.masksToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imgView];
    }
}

- (void)yd_layoutConstraints {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(0);
    }];
}

- (void)setModel:(YD_FilterModel *)model {
    self.imgView.image = model.filterImage;
    
    if (model.isSelected) {
        self.imgView.layer.borderWidth = 2.0;
        self.imgView.layer.borderColor = UIColor.redColor.CGColor;
    }else {
        self.imgView.layer.borderWidth = 0.0;
        self.imgView.layer.borderColor = UIColor.clearColor.CGColor;
    }
}

@end
