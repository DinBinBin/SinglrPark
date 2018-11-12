//
//  NSAttributedString+ZExtension.h
//  KYFinance
//
//  Created by Zhang_yD on 16/4/19.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (ZExtension)

+ (instancetype _Nullable )attributedStringWithString:(NSString *_Nullable)string attributes:(nullable NSDictionary<NSString *, id> *)attr subStr:(NSString *_Nullable)subStr subStrAttributes:(nullable NSDictionary<NSString *, id> *)subStrAttr;

@end
