//
//  YD_AVFilterLayer.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "YD_VideoEditManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD_AVFilterLayer : CALayer

@property (nonatomic, retain, nullable) AVPlayer *player;

@property (nonatomic, copy, nullable) NSString *filterName;

@end

NS_ASSUME_NONNULL_END
