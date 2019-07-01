//
//  ViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "YD_RotateViewController.h"
#import "YD_SpeedViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL isSpeed;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"首页";
    
    [self yd_createButton:@"旋转" index:0];
    [self yd_createButton:@"变速" index:1];
}

- (void)yd_createButton:(NSString *)title index:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 60, 100 + index * 100, 120, 60);
    button.backgroundColor = UIColor.orangeColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [button addTarget:self action:@selector(yd_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)yd_buttonAction:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
            [self yd_rotate];
            break;
        case 1:
            [self yd_changeSpeed];
            break;
    }
}

// 旋转
- (void)yd_rotate {
    self.isSpeed = NO;
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    /// 录制的类型 下面为视频
    picker.mediaTypes = @[(NSString*)kUTTypeMovie];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

// 变速
- (void)yd_changeSpeed {
    self.isSpeed = YES;
    
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    /// 录制的类型 下面为视频
    picker.mediaTypes = @[(NSString*)kUTTypeMovie];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    /// 返回的媒体类型是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        /// 视频的处理
        [picker dismissViewControllerAnimated:YES completion:^() {
            
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            
            if (self.isSpeed) {
                YD_SpeedModel *model = [YD_SpeedModel new];
                model.asset = [AVAsset assetWithURL:url];
                
                YD_SpeedViewController *vc = [YD_SpeedViewController new];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];

            }else {
                YD_RotateModel *model = [YD_RotateModel new];
                model.asset = [AVAsset assetWithURL:url];
                
                YD_RotateViewController *vc = [YD_RotateViewController new];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}

@end
