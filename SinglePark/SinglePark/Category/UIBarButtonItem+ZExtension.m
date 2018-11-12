//
//  UIBarButtonItem+ZExtension.m
//  KYFinance
//
//  Created by Zhang_yD on 16/4/20.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import "UIBarButtonItem+ZExtension.h"

@implementation UIBarButtonItem (ZExtension)

+ (instancetype)backBarButtonWithTarget:(id)target action:(SEL)action {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 30);
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
