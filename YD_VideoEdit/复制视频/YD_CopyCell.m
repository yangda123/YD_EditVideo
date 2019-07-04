//
//  YD_CopyCell.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_CopyCell.h"
#import "YD_VideoEditManager.h"

@interface YD_CopyCell ()

@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UILabel *timeLbl;

@end

@implementation YD_CopyCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
    }
    return self;
}

#pragma mark - 子类重写方法
/// cell的heigth
+ (CGSize)yd_cellSize {
    return CGSizeMake(YD_IPhone7_Width(100), YD_IPhone7_Width(100));
}

/// 初始化UI
- (void)yd_layoutSubViews {
    {
        UIImageView *imgView = [UIImageView new];
        self.imgView = imgView;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        imgView.backgroundColor = UIColor.yellowColor;
        [self.contentView addSubview:imgView];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn = button;
        button.imageEdgeInsets = UIEdgeInsetsMake(-3, 3, 3, -3);
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage yd_imageWithName:@"yd_copy_close@3x"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(yd_deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
    {
        UILabel *label = [UILabel new];
        self.timeLbl = label;
        label.textColor = UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:label];
    }
}

/// 布局UI
- (void)yd_layoutConstraints {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.inset(10);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.inset(0);
        make.size.mas_equalTo(30);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.inset(13);
    }];
}

- (void)playModel:(YD_PlayerModel *)model row:(NSInteger)row {
    self.imgView.image = model.smallImage;
    self.closeBtn.hidden = row == 0;
    self.timeLbl.text = [NSString timeToString:[model.asset yd_getSeconds] format:@"%zd\"%zd"];
}

- (void)yd_deleteAction {
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

@end
