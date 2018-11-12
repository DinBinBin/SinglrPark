//
//  UIView+ZExtension.h
//  KYFinance
//
//  Created by Zhang_yD on 16/5/24.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZExtension)

/** 显示警示标语 */
- (void)showRegularExpressionAlertMessage:(NSString *)message;
/** 移去警示标语 */
- (void)removeRegularExpressionAlertMessage;

/** 设置圆角 */
- (void)makeCornerWithRadius:(float)radius;

/** 添加点击手势 */
- (void)addTapGestureRecognizerWithTarget:(id)target acion:(SEL)action;


- (CGFloat)x;
- (CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (CGFloat)maxX;
- (CGFloat)maxY;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;


@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;
@end
