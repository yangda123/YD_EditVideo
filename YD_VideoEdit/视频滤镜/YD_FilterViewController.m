//
//  YD_FilterViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_FilterViewController.h"
#import "YD_FilterCollectionView.h"

@interface YD_FilterViewController () <GPUImageMovieDelegate>

@property (nonatomic, weak) YD_FilterCollectionView *filterCollection;

@property (nonatomic, strong) GPUImageView *filterView;//播放视图
@property (nonatomic, strong) GPUImageMovie *movie;//播放
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *imgOutput;//滤镜
@property (nonatomic, strong) GPUImageMovieWriter *writer;//保存

@property (nonatomic, strong) AVPlayer *avPlayer;

@end

@implementation YD_FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)yd_layoutSubViews {
    [super yd_layoutSubViews];
    {
        self.filterView = [GPUImageView new];
        [self.view addSubview:self.filterView];
        
        self.avPlayer = [[AVPlayer alloc] initWithURL:self.model.videoURL];
        
        self.movie = [[GPUImageMovie alloc] initWithURL:self.model.videoURL];
        self.movie.playAtActualSpeed = YES;
        self.movie.delegate = self;
    
        self.imgOutput = [[GPUImageSepiaFilter alloc] init];
        
        [self.movie addTarget:self.imgOutput];
        [self.imgOutput addTarget:self.filterView];
        [self.movie startProcessing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.avPlayer play];
        });
    }
    {
        YD_FilterCollectionView *view = [YD_FilterCollectionView new];
        self.filterCollection = view;
        view.image = [self.model.asset yd_getVideoImage:0];
        [self.view addSubview:view];
        
        @weakify(self);
        view.filterBlock = ^(GPUImageOutput<GPUImageInput> *imgOutput) {
            @strongify(self);
            self.imgOutput = imgOutput;

            [self.movie removeAllTargets];
            [self.movie addTarget:self.imgOutput];
            [self.imgOutput addTarget:self.filterView];
        };
    }
}

- (void)yd_layoutConstraints {
    [super yd_layoutConstraints];
    
    CGFloat topInset = self.navigationController.navigationBar.translucent ? YD_TopBarHeight : 0;
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.inset(topInset);
        make.height.equalTo(self.filterView.mas_width);
    }];
    
    [self.filterCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.top.equalTo(self.filterView.mas_bottom);
        make.bottom.equalTo(self.bottomBar.mas_top);
    }];
}

#pragma mark - 重写的方法
- (NSString *)yd_title {
    return @"滤镜";
}

- (UIImage *)yd_barIconImage {
    return self.model.barIconImage ?: [UIImage yd_imageWithName:@"yd_aspectRatio@3x"];
}

- (void)yd_completeItemAction {
    
}

#pragma mark - GPUImageMovieDelegate
- (void)didCompletePlayingMovie {
    
    self.movie = nil;

    self.movie = [[GPUImageMovie alloc] initWithURL:self.model.videoURL];
    self.movie.playAtActualSpeed = YES;
    self.movie.delegate = self;
    
    self.imgOutput = [[GPUImageSepiaFilter alloc] init];
    
    [self.movie addTarget:self.imgOutput];
    [self.imgOutput addTarget:self.filterView];
    [self.movie startProcessing];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{[self.avPlayer.currentItem seekToTime:CMTimeMakeWithSeconds(0, self.avPlayer.currentItem.duration.timescale)];
        [self.avPlayer play];
    });
}

@end
