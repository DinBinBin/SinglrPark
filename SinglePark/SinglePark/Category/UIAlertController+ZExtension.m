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

@end
