//
//  JDWConst.m
//  JDWin_B
//
//  Created by Chensw on 2018/5/11.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import "JDWConst.h"


NSString *const kDefultsFaceImage = @"seting_avatar_bg"; // 默认背景头像



// ----------------------------------------NSUserDefults key--------------------------------------------//
/**判断是否出现过app引导页*/
NSString *const kAPPGuidePage = @"isGuidePage";
NSString *const kGesturesPasswordEnabledUserDefaults = @"kGesturesPasswordEnabledUserDefaults"; // 手势密码使能
NSString *const kTouchIDEnabledUserDefaults = @"kTouchIDEnabledUserDefaults"; // TouchID功能
NSString *const kUserFace = @"face"; // 用户头像
NSString *const kUserName = @"userName"; // 用户昵称
NSString *const kUserNamePlaceHolder = @"userNamePlaceHolder"; // 记录上次登录的用户名
NSString *const USER_INFO = @"USER_INFO"; // 记录上次登录的用户名
NSString *const kZipPath = @"zipPath"; // H5zip包名
NSString *const kUnzipPath = @"unzipPath"; // 解压包
NSString *const kUnzipPathCaches = @"unzipPathCaches"; // 缓存包
NSString *const kH5JarVersionIOS = @"h5JarVersionIOS"; // 缓存包





// ----------------------------------------NSNotificationCenter key--------------------------------------------//


/** 弹出手势密码登录 */
NSString *const kNotificationPresentGestureLogin = @"kNotificationPresentGestureLogin";
NSString *const kNotificationDismissGestureLogin = @"kNotificationDismissGestureLogin";// 手势密码消失
NSString *const kNotificatiobLoginout = @"notificatiobHomelogout";// 账户退出
NSString *const kNotificationNewUserLoginSuccessed = @"kNotificationNewUserLoginSuccessed";// 新手登录成功或手势密码设置成功

NSString *const kNotificationNewsUpdate = @"kNotificationNewsUpdate";  //新消息
NSString *const kNotificationFunctionName = @"kNotificationFunctionName";  //新消息key
NSString *const kNotificationNewsValueName = @"kNotificationNewsValueName";  //新消息value
NSString *const KunreadNum = @"unreadNum";  //设置没有红点

NSString *const kNotificationStopTimer = @"kNotificationStopTimer";  //停止定时器
NSString *const kNotificationStartTimer = @"kNotificationStartTimer";  //开启定时器
NSString *const kNotificationDownloadH5Zip = @"kNotificationDownloadH5Zip";  //下载H5包


/************************* 下载 *************************/
NSString * const HWDownloadProgressNotification = @"HWDownloadProgressNotification";
NSString * const HWDownloadStateChangeNotification = @"HWDownloadStateChangeNotification";
NSString * const HWDownloadMaxConcurrentCountKey = @"HWDownloadMaxConcurrentCountKey";
NSString * const HWDownloadMaxConcurrentCountChangeNotification = @"HWDownloadMaxConcurrentCountChangeNotification";
NSString * const HWDownloadAllowsCellularAccessKey = @"HWDownloadAllowsCellularAccessKey";
NSString * const HWDownloadAllowsCellularAccessChangeNotification = @"HWDownloadAllowsCellularAccessChangeNotification";

/************************* 网络 *************************/
NSString * const HWNetworkingReachabilityDidChangeNotification = @"HWNetworkingReachabilityDidChangeNotification";

/** 融云appkey */
NSString * const RYAPPKey = @"sfci50a7s36wi";
//生产环境
//NSString * const RYAPPKey = @"y745wfm8yqo3v";

