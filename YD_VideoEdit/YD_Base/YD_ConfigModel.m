//
//  YD_ConfigModel.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_ConfigModel.h"
#import "UIColor+YDColorChange.h"

@implementation YD_ConfigModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.controllerColor = [UIColor colorWithHexString:@"#E8E8E8"];
        self.playerBackColor = [UIColor colorWithHexString:@"#BABABA"];
        self.themeColor = [UIColor colorWithHexString:@"#F61847"];
    }
    return self;
}

@end
