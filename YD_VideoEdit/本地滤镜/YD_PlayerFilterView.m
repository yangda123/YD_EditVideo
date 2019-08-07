//
//  YD_PlayerFilterView.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_PlayerFilterView.h"
#import "YD_PlayerFilterCell.h"

@interface YD_PlayerFilterView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation YD_PlayerFilterView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        [self yd_layoutSubViews];
        [self yd_layoutConstraints];
    }
    return self;
}

/// 初始化UI
- (void)yd_layoutSubViews {
    {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = [YD_PlayerFilterCell yd_cellSize];
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView = collectionView;
        collectionView.backgroundColor = UIColor.clearColor;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:YD_PlayerFilterCell.class forCellWithReuseIdentifier:@"YD_PlayerFilterCell"];
        [self addSubview:collectionView];
    }
}

/// 布局UI
- (void)yd_layoutConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(80);
    }];
}

- (void)setImage:(UIImage *)image {
    UIImage *smallImg = [UIImage scaleImageWith:image targetWidth:80];
    
    self.selectIndex = 0;
    
    NSArray *filterArr = @[@"CIPhotoEffectInstant",
                           @"CIPhotoEffectProcess",
                           @"CIPhotoEffectChrome",
                           @"CIPhotoEffectMono",
                           @"CIPhotoEffectFade",
                           @"CIPhotoEffectNoir",
                           @"CIPhotoEffectTransfer",
                           @"CIPhotoEffectTonal"];
    
    dispatch_async(dispatch_queue_create("reload.queue", DISPATCH_QUEUE_SERIAL), ^{
        for (int i = 0; i < filterArr.count; i++) {
            NSString *filterName = filterArr[i];
            
            YD_PlayerFilterModel *model = [YD_PlayerFilterModel new];
            if (i == 0) { model.isSelected = YES; }
            model.filterName = filterName;
            model.filterImage = [smallImg filterName:filterName];
            [self.dataArray addObject:model];
            
            if (self.dataArray.count % 3 == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - tableView datasource && delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YD_PlayerFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YD_PlayerFilterCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectIndex == indexPath.row) {
        return;
    }
    
    YD_PlayerFilterModel *old_model = self.dataArray[self.selectIndex];
    YD_PlayerFilterModel *new_model = self.dataArray[indexPath.row];
    
    old_model.isSelected = NO;
    new_model.isSelected = YES;
    self.selectIndex = indexPath.row;
    
    [collectionView reloadData];
    
    if (self.filterBlock) {
        self.filterBlock(new_model.filterName);
    }
}

@end
