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
#import "YD_VolumeViewController.h"
#import "YD_CompressViewController.h"
#import "YD_CopyViewController.h"
#import "YD_ClipViewController.h"

#import <TZImagePickerController.h>

@interface ViewController () <TZImagePickerControllerDelegate>

@property (nonatomic, weak) UIButton *currentBtn;

@property (nonatomic, strong) NSArray *classArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"首页";
    
    self.classArray = @[YD_RotateViewController.class,
                        YD_SpeedViewController.class,
                        YD_UpendViewController.class,
                        YD_AspectRatioViewController.class,
                        
                        YD_CopyViewController.class,
                        YD_CompressViewController.class,
                        YD_VolumeViewController.class,
                        
                        YD_ClipViewController.class];
    
    [self yd_createButton:@"旋转" index:0];
    [self yd_createButton:@"变速" index:1];
    [self yd_createButton:@"倒放" index:2];
    [self yd_createButton:@"宽高比" index:3];
    
    [self yd_createButton:@"复制" index:4];
    [self yd_createButton:@"压缩" index:5];
    [self yd_createButton:@"音量" index:6];
    
    [self yd_createButton:@"裁剪" index:7];
}

- (void)yd_createButton:(NSString *)title index:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 60, YD_TopBarHeight + 20 + index * 64, 120, 44);
    button.backgroundColor = UIColor.orangeColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [button addTarget:self action:@selector(yd_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)yd_buttonAction:(UIButton *)btn {
    
    self.currentBtn = btn;
    
    [self pushTZImagePickerController];
}

- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    // 修正方向
    imagePicker.needFixComposition = YES;
    // 是否允许显示视频
    imagePicker.allowPickingVideo = YES;
    // 是否允许显示图片
    imagePicker.allowPickingImage = NO;
    // 是否显示可选原图按钮
    imagePicker.allowPickingOriginalPhoto = NO;
    // 在内部显示拍照按钮
    imagePicker.allowTakePicture = NO;
    // 在内部显示拍视频按
    imagePicker.allowTakeVideo = NO;
    // 这是一个navigation 只能present
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
// 选择视频的回调
-(void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingVideo:(UIImage *)coverImage
                sourceAssets:(PHAsset *)asset {
    [YD_ProgressHUD yd_showHUD:@"正在压缩视频"];
    
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetMediumQuality success:^(NSString *outputPath) {
        [YD_ProgressHUD yd_hideHUD];
        
        NSURL *url = [NSURL fileURLWithPath:outputPath];
        
        YD_ConfigModel *model = [YD_ConfigModel new];
        model.videoURL = url;
        
        Class class = self.classArray[self.currentBtn.tag];
        YD_BasePlayerViewController *playerVC = (YD_BasePlayerViewController *)[class new];
        playerVC.model = model;
        [self.navigationController pushViewController:playerVC animated:YES];
        
        playerVC.saveBlock = ^(UIViewController * _Nonnull controller, NSString * _Nonnull urlPaht) {
            NSLog(@"--- 保存");
        };
        
        playerVC.shareBlock = ^(UIViewController * _Nonnull controller, NSString * _Nonnull urlPaht) {
            NSLog(@"--- 分享");
        };
        
    } failure:^(NSString *errorMessage, NSError *error) {
        [YD_ProgressHUD yd_hideHUD];
        [YD_ProgressHUD yd_showMessage:@"视频导出失败"];
    }];
}

@end
