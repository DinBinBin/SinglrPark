//
//  NSDictionary+ZExtension.m
//  KYFinance
//
//  Created by Zhang_yD on 16/4/19.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import "NSDictionary+ZExtension.h"

@implementation NSDictionary (ZExtension)

+ (instancetype)attrDictWithFont:(UIFont *)font color:(UIColor *)color {
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    if (font) {
        [mDict setObject:font forKey:NSFontAttributeName];
    }
    if (color) {
        [mDict setObject:color forKey:NSForegroundColorAttributeName];
    }
    return mDict;
}

@end
