//
//  UIView+KJFrame.h
//  自定义转场解决navigationBar颜色转换问题
//
//  Created by coder on 2017/6/29.
//  Copyright © 2017年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KJFrame)
@property (assign, nonatomic) CGFloat kj_x;
@property (assign, nonatomic) CGFloat kj_y;
@property (assign, nonatomic) CGFloat kj_width;
@property (assign, nonatomic) CGFloat kj_height;
@property (assign, nonatomic) CGFloat kj_centerX;
@property (assign, nonatomic) CGFloat kj_centerY;
@end
