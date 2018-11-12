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

@interface AppDelegate ()
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

//    if (self.versionStr==nil || [self.versionStr intValue] != [currentAppVersion intValue]) {
//        self.versionStr = currentAppVersion;
//        [userdef setObject:self.versionStr forKey:@"versionStr"];
//        GuideViewController *guid = [[GuideViewController alloc] init];
//        self.window.rootViewController = guid;
//
//    }else{ //判断是否是登录状态
//    [self setUI];
    [DBAccountInfo sharedInstance].model = [JDWUserInfoDB userInfo];
    
    
//        if(token){
//            SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
//            self.window.rootViewController = sgTabBar;
//
//        }else{
            SGNavigationController *nav = [[SGNavigationController alloc] initWithRootViewController:[[SPWelcomeController alloc] init]];
            self.window.rootViewController = nav;
//        }

//    }
    return YES;
    
}

- (void)setUI{
        SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
        self.window.rootViewController = sgTabBar;
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
