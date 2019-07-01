//
//  ViewController.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "YD_RotateViewController.h"
#import "YD_SpeedViewController.h"
#import "YD_UpendViewController.h"
#import "YD_AspectRatioViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIButton *currentBtn;

@property (nonatomic, strong) NSArray *classArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"首页";
    
    self.classArray = @[YD_RotateViewController.class,
                        YD_SpeedViewController.class,
                        YD_UpendViewController.class,
                        YD_AspectRatioViewController.class];
    
    [self yd_createButton:@"旋转" index:0];
    [self yd_createButton:@"变速" index:1];
    [self yd_createButton:@"倒放" index:2];
    [self yd_createButton:@"宽高比" index:3];
}

- (void)yd_createButton:(NSString *)title index:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 60, YD_TopBarHeight + 20 + index * 80, 120, 60);
    button.backgroundColor = UIColor.orangeColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [button addTarget:self action:@selector(yd_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)yd_buttonAction:(UIButton *)btn {
    
    self.currentBtn = btn;
    
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
            
            YD_ConfigModel *model = [YD_ConfigModel new];
            model.asset = [AVAsset assetWithURL:url];
            
            Class class = self.classArray[self.currentBtn.tag];
            YD_BasePlayerViewController *playerVC = (YD_BasePlayerViewController *)[class new];
            playerVC.model = model;
            [self.navigationController pushViewController:playerVC animated:YES];
        }];
    }
}

@end
