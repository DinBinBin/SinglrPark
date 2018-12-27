//
//  AppDelegate.m
//  SinglePark
//
//  Created by DBB on 2018/8/12.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "AppDelegate.h"
#import "SGTabBarController.h"
#import "SPWelcomeController.h"
#import "SGNavigationController.h"
#import <RongIMKit/RongIMKit.h>

#define  RYUserToken1000 @"AjTYNx3b/+s2xWSS2JY4BKxnGDTFFrRJfvWcZPs7rYutDT/fvqtighn9ixKpJpsl/3FGJyBJltMzzsIKnel3bQ=="
#define  RYUserToken1001 @"8aDnTVlww4leOYuTEhYX4q2QImwLq/9Snm4W+9UbcP3+iHOGBOqqYcITkmdM4ZQYWMG6hqGz/AnTP0YEtcnShA=="
@interface AppDelegate ()<RCIMReceiveMessageDelegate>
@property(nonatomic,copy)NSString *versionStr;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentAppVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    self.versionStr = [userdef objectForKey:@"versionStr"];
    
//        GuideViewController *guid = [[GuideViewController alloc] init];
//        self.window.rootViewController = guid;
//
//    if (self.versionStr==nil || [self.versionStr intValue] != [currentAppVersion intValue]) {
//        self.versionStr = currentAppVersion;
//        [userdef setObject:self.versionStr forKey:@"versionStr"];
//        GuideViewController *guid = [[GuideViewController alloc] init];
//        self.window.rootViewController = guid;
//
//    }else{ //判断是否是登录状态
//    [self setUI];
//    [DBAccountInfo sharedInstance].model = [JDWUserInfoDB userInfo];
    
        if([ND objectForKey:isLogin]){
            if ([[ND objectForKey:isLogin] isEqualToString:@""]) {
                [DBAccountInfo sharedInstance].islogin = NO;
                [DBAccountInfo sharedInstance].isTouris = YES;

            }else{
                [DBAccountInfo sharedInstance].islogin = YES;
                [DBAccountInfo sharedInstance].isTouris = NO;
                [DBAccountInfo sharedInstance].token = [ND objectForKey:isLogin];
                
            }
            SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
            self.window.rootViewController = sgTabBar;
            
        }else{
            [DBAccountInfo sharedInstance].islogin = NO;
            SGNavigationController *nav = [[SGNavigationController alloc] initWithRootViewController:[[SPWelcomeController alloc] init]];
            self.window.rootViewController = nav;
        }

//    }

    /** 注册融云 */
    [self registRYAPIWith:application];
    
    return YES;
    
}


- (void)setUI{
        SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
        self.window.rootViewController = sgTabBar;
}

/** 注册融云相关信息 */
- (void)registRYAPIWith:(UIApplication *)application{
    
    [[RCIM sharedRCIM] initWithAppKey:RYAPPKey];
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    
    // 登陆
    [[RCIM sharedRCIM] connectWithToken:RYUserToken1000 success:^(NSString *userId) {
        JDWLog(@"登陆成功userid＝%@",userId);
    } error:^(RCConnectErrorCode status) {
        JDWLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        JDWLog(@"token错误");
    }];
    
    // 消息推送
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    
}

// 接收消息通知
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    JDWLog(@"message:%@",message);

}




/**
 *  将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
 *
 *  @param application <#application description#>
 *  @param deviceToken <#deviceToken description#>
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
