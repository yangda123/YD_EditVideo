//
//  YD_BaseModel.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_BaseModel.h"

@implementation YD_BaseModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.yd_topOffsetY = YD_TopBarHeight;
        self.controllerColor = [UIColor colorWithHexString:@"#E8E8E8"];
        self.playerBackColor = [UIColor colorWithHexString:@"#BABABA"];
        
        NSURL *url = [NSURL fileURLWithPath:[NSBundle.mainBundle pathForResource:@"DreamHouseClip" ofType:@"mp4"]];
        self.asset = [AVAsset assetWithURL:url];
    }
    return self;
}

@end
