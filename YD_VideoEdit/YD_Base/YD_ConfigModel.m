//
//  YD_ConfigModel.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_ConfigModel.h"
#import "UIColor+YDColorChange.h"

@interface YD_ConfigModel ()
/// 视频播放
@property (nonatomic, strong) AVAsset *asset;

@end

@implementation YD_ConfigModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.controllerColor = [UIColor colorWithHexString:@"#E8E8E8"];
        self.playerBackColor = [UIColor colorWithHexString:@"#BABABA"];
        self.themeColor = [UIColor colorWithHexString:@"#F61847"];
        self.btnTitleColor = [UIColor colorWithHexString:@"#000000"];
    }
    return self;
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    self.asset = [AVAsset assetWithURL:videoURL];
}

@end
