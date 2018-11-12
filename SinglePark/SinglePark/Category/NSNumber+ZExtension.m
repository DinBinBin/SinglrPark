//
//  NSNumber+ZExtension.m
//  KYFinance
//
//  Created by Zhang_yD on 16/4/19.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import "NSNumber+ZExtension.h"

@implementation NSNumber (ZExtension)

- (NSString *)formaterWithDecimalStyle {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:self];
}

@end
