//
//  YD_CopyView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_CopyView.h"
#import "YD_CopyCell.h"

@interface YD_CopyView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIView *yd_copyBtn;

@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation YD_CopyView

- (instancetype)initWithModel:(YD_PlayerModel *)model {
    self = [super init];
    if (self) {
        self.modelArray = [NSMutableArray arrayWithCapacity:0];
        [self.modelArray addObject:model];
        
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
    }
    return self;
}

- (void)yd_layoutSubViews {
    {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = [YD_CopyCell yd_cellSize];
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView = collection;
        collection.backgroundColor = UIColor.clearColor;
        collection.showsVerticalScrollIndicator = NO;
        collection.showsHorizontalScrollIndicator = NO;
        collection.dataSource = self;
        collection.delegate = self;
        [collection registerClass:YD_CopyCell.class forCellWithReuseIdentifier:@"YD_CopyCell"];
        [self addSubview:collection];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.yd_copyBtn = button;
        button.adjustsImageWhenHighlighted = NO;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4.0;
        [button setTitle:@"点击复制视频" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(yd_copyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)yd_layoutConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.centerY.equalTo(self).offset(-13 - YD_IPhone7_Width(7.5));
        make.height.mas_equalTo([YD_CopyCell yd_cellSize].height);
    }];
    
    [self.yd_copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(118);
        make.height.mas_equalTo(26);
        make.centerX.mas_equalTo(self);
        make.top.equalTo(self.collectionView.mas_bottom).inset(YD_IPhone7_Width(15));
    }];
}

#pragma mark - setter
- (void)setThemeColor:(UIColor *)themeColor {
    self.yd_copyBtn.backgroundColor = themeColor;
}

#pragma mark - UI事件
- (void)yd_copyBtnAction {
    if (!self.modelArray.count) { return; }
    
    YD_PlayerModel *model = self.modelArray.firstObject;
    
    BOOL flag = NO;
    if ([model.asset yd_getSeconds] * (self.modelArray.count + 1) < 3600) {
        flag = YES;
    }
    
    if (flag) {
        YD_PlayerModel *copyModel = [YD_PlayerModel new];
        copyModel.asset = model.asset;
        copyModel.coverImage = model.coverImage;
        copyModel.smallImage = model.smallImage;
        
        [self.modelArray addObject:copyModel];
        [self.collectionView reloadData];
    }
    
    if (self.copyBlock) {
        self.copyBlock(self.modelArray, flag);
    }
}

- (void)yd_deleteAction:(YD_CopyCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    YD_PlayerModel *model = self.modelArray[indexPath.row];
    
    [self.modelArray removeObject:model];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self.collectionView reloadData];
    
    if (self.copyBlock) {
        self.copyBlock(self.modelArray, YES);
    }
}

#pragma mark - tableView datasource && delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

/// 子类重写
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YD_CopyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YD_CopyCell" forIndexPath:indexPath];
    [cell playModel:self.modelArray[indexPath.row] row:indexPath.row];
    @weakify(self);
    cell.deleteBlock = ^(YD_CopyCell * _Nonnull copyCell) {
        @strongify(self);
        [self yd_deleteAction:copyCell];
    };
    return cell;
}

@end
