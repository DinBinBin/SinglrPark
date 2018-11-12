//
//  UIView+JDW.h
//  JDWin_B
//
//  Created by DBB1 on 2018/6/7.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JDW)

- (void)setCornerRadius; //设置半圆
- (void)setCornerRadius:(CGFloat)value; //设置自定义大小圆角
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner;//指定圆角
- (UIViewController *)viewController;

@end
