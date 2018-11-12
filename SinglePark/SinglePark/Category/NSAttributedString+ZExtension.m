//
//  NSAttributedString+ZExtension.m
//  KYFinance
//
//  Created by Zhang_yD on 16/4/19.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import "NSAttributedString+ZExtension.h"


@implementation NSAttributedString (ZExtension)

+ (instancetype)attributedStringWithString:(NSString *)string attributes:(nullable NSDictionary<NSString *, id> *)attr subStr:(NSString *)subStr subStrAttributes:(nullable NSDictionary<NSString *, id> *)subStrAttr {
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:attr]];
    if (subStr) {
        [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:subStr attributes:subStrAttr]];
    }
    return attrStr;
}


@end
