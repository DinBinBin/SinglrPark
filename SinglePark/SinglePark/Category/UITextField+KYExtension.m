//
//  UITextField+KYExtension.m
//  KYFinance
//
//  Created by Zhang_yD on 16/3/29.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import "UITextField+KYExtension.h"

@implementation UITextField (KYExtension)

- (void)setPlaceHolderWithString:(NSString *)string color:(UIColor *)color {
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : color}];
    self.attributedPlaceholder = attrStr;
}

@end
