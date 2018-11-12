//
//  NSString+ZExtension.h
//  KYFinance
//
//  Created by Zhang_yD on 16/4/21.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VREType) {
    VRETypeUsername = 0, // 用户名
    VRETypeIDCard,  // 身份证号码
    VRETypePhoneNumber,  // 电话号码
    VRETypeApr,  // 年化收益
    VRETypeTender,  // 投资金额
    VRETypePassword, // 密码
    VRETypeAddressName,  // 姓名
    VRETypePostalcode,  // 邮箱
    VRETypeAddress  // 地址
};

@interface NSString (ZExtension)

- (BOOL)isValidateRegularExpressionWithType:(VREType)type;

@end
