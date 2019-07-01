//
//  YD_CGAffineManager.m
//  YD_VideoEidtManager
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "YD_CGAffineManager.h"


@implementation YD_CGAffineManager

+ (NSUInteger)yd_orientation:(CGAffineTransform)transform {
    
    CGAffineTransform t = transform;
    NSUInteger degress = 0;
    
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {
        degress = 90;
    }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
        degress = 270;
    }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
        degress = 0;
    }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        degress = 180;
    }
    return degress;
}

@end
