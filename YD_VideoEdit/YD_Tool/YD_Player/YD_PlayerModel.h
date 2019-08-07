//
//  YD_PlayerModel.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YD_PlayerModel : NSObject

@property (nonatomic, strong, nonnull) AVAsset *asset;
@property (nonatomic, strong, nonnull) AVMutableAudioMix *audioMix;
@property (nonatomic, strong, nonnull) AVMutableVideoComposition *composition;
@property (nonatomic, strong, nonnull) UIImage *coverImage;
@property (nonatomic, strong, nonnull) UIImage *smallImage;
@property (nonatomic, assign) CGSize naturalSize;

@end

NS_ASSUME_NONNULL_END
