//
//  YD_PlayerFilterModel.h
//  YD_VideoEidtManager
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YD_PlayerFilterModel : NSObject

@property (nonatomic, copy  ) NSString *filterName;
@property (nonatomic, strong) UIImage *filterImage;
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
