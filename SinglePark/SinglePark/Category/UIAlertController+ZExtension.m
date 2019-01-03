//
//  UIAlertController+ZExtension.m
//  KYFinance
//
//  Created by Zhang_yD on 16/5/24.
//  Copyright © 2016年 51KuaiYing. All rights reserved.
//

#import "UIAlertController+ZExtension.h"
#import "UIColor+ZExtension.h"

#define kAlertTitle @"提示"
#define kAlertMsgOk @"确认"
#define kAlertMsgCancel @"取消"

@implementation UIAlertController (ZExtension)

+ (void)showNormalAlertVCInVC:(UIViewController *)rootVC
                      message:(NSString *)message
                        style:(UIAlertControllerStyle)style
                           ok:(void (^ __nullable)())okHandler
                       cancel:(void (^ __nullable)())cancelHandler {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:kAlertTitle message:message preferredStyle:style];
    alertController.view.tintColor = [UIColor colorWithHex:0xea7400];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:kAlertMsgCancel style:UIAlertActionStyleCancel handler:cancelHandler];
    UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;
    if (style == UIAlertControllerStyleActionSheet) {
        actionStyle = UIAlertActionStyleDestructive;
    }
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:kAlertMsgOk style:actionStyle handler:okHandler];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [rootVC presentViewController:alertController animated:YES completion:nil];
}

+ (void)showInfoAlertVCInVC:(UIViewController *)rootVC
                    message:(NSString *)message
                         ok:(void (^ __nullable)())okHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor colorWithHex:0xea7400];
    UIAlertAction *action = [UIAlertAction actionWithTitle:kAlertMsgOk style:UIAlertActionStyleDefault handler:okHandler];
    [alertController addAction:action];
    [rootVC presentViewController:alertController animated:YES completion:nil];
}

+ (void)showNormalAlert:(UIViewController *)rootVC
                messafe:(NSString *)message
                 lefStr:(NSString *)leftStr
               rightStr:(NSString *)rightStr
                   left:(void (^)(void))leftBlock
                  right:(void (^)(void)) rightBlock
              leftColor:(UIColor *)leftColor
             rightColor:(UIColor *)rightColor{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:FirstWordColor range:NSMakeRange(0, message.length)];
    //    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, message.length)];
    
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:leftStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (leftBlock) {
            leftBlock();
        }
    }];
    UIAlertActionStyle actionStyle = UIAlertActionStyleDefault;
    
    [action1 setValue:leftColor forKey:@"_titleTextColor"];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:rightStr style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        if (rightBlock) {
            rightBlock();
        }
    }];
    [action2 setValue:rightColor forKey:@"_titleTextColor"];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [rootVC presentViewController:alertController animated:YES completion:nil];
    
}


@end
