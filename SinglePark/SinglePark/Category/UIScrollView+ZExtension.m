//
//  UIScrollView+ZExtension.m
//  KYFinance
//
//  Created by Zhang_yD on 16/5/24.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import "UIScrollView+ZExtension.h"

@implementation UIScrollView (ZExtension)

- (void)moveWithOffset:(CGFloat)offset {
    if (self.contentInset.top != offset) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
        }];
    }
}

@end
