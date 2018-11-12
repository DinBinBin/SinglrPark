//
//  UIView+JDW.m
//  JDWin_B
//
//  Created by DBB1 on 2018/6/7.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import "UIView+JDW.h"

@implementation UIView (JDW)

- (void)setCornerRadius{
    [self layoutIfNeeded];
    UIRectCorner rectCorner = UIRectCornerAllCorners;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.height, self.height)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;

    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.size];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    //设置大小
//    maskLayer.frame = self.bounds;
//    //设置图形样子
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;

}

- (void)setCornerRadius:(CGFloat)value {
    [self layoutIfNeeded];
    UIRectCorner rectCorner = UIRectCornerAllCorners;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner{
    [self layoutIfNeeded];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
