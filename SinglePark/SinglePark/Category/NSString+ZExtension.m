//
//  NSString+ZExtension.m
//  KYFinance
//
//  Created by Zhang_yD on 16/4/21.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import "NSString+ZExtension.h"

@implementation NSString (ZExtension)

- (BOOL)isValidateRegularExpressionWithType:(VREType)type {
    
    static NSDictionary *verDict;
    if (!verDict) {
        verDict = @{@(VRETypeUsername) : @"^(?![0-9]+$)[0-9A-Za-z]{4,16}$",
                    @(VRETypeIDCard) : @"^.{18}$",
                    @(VRETypePhoneNumber) : @"^1[2|3|4|5|6|7|8|9][0-9]\\d{8}$",
                    @(VRETypeApr) : @"^(\\d{1,2}(\\.\\d{1,2})?|100|100.0|100.00)$",
                    @(VRETypeTender) : @"^([0-9]{3,10})$",
                    @(VRETypePassword) : @"[0-9A-Za-z]{6,12}",
                    @(VRETypeAddressName) : @"^.{1,20}$",
                    @(VRETypePostalcode) : @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$",
                    @(VRETypeAddress) : @"^.{0,128}$",};
    }
    
    if (!verDict[@(type)]) {
        NSLog(@"正则表达式不存在");
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verDict[@(type)]];
    return [predicate evaluateWithObject:self];
}

@end
