//
//  UIButton+ZExtension.h
//  KYFinance
//
//  Created by Zhang_yD on 16/5/24.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StartBlock)(void);
typedef void(^CompleteBlock)(void);

@interface UIButton (ZExtension)

/** 添加一个倒数的计时器(用于发送验证码) */
- (void)addTimerForVerifyWithInterval:(NSUInteger)interval start:(StartBlock)startBlock complete:(CompleteBlock)completeBlock;
- (void)verifyButtonClick:(UIButton *)button;

@end
