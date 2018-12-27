//
//  JDWConst.h
//  JDWin_B
//
//  Created by Chensw on 2018/5/11.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JDWClickCallBackBlock)(void);  //点击回调block

UIKIT_EXTERN NSString *const kDefultsFaceImage;



// ----------------------------------------NSUserDefults key--------------------------------------------//
UIKIT_EXTERN NSString *const kAPPGuidePage;
UIKIT_EXTERN NSString *const kGesturesPasswordEnabledUserDefaults;
UIKIT_EXTERN NSString *const kTouchIDEnabledUserDefaults;
UIKIT_EXTERN NSString *const kUserFace;
UIKIT_EXTERN NSString *const kUserName;
UIKIT_EXTERN NSString *const kUserNamePlaceHolder;
UIKIT_EXTERN NSString *const USER_INFO;
UIKIT_EXTERN NSString *const kZipPath;
UIKIT_EXTERN NSString *const kUnzipPath;
UIKIT_EXTERN NSString *const kUnzipPathCaches;
UIKIT_EXTERN NSString *const kH5JarVersionIOS;




// ----------------------------------------NSNotificationCenter key--------------------------------------------//

UIKIT_EXTERN NSString *const kNotificationPresentGestureLogin;
UIKIT_EXTERN NSString *const kNotificationDismissGestureLogin;
UIKIT_EXTERN NSString *const kNotificatiobLoginout;
UIKIT_EXTERN NSString *const kNotificationNewUserLoginSuccessed;

UIKIT_EXTERN NSString *const kNotificationNewsUpdate;
UIKIT_EXTERN NSString *const kNotificationFunctionName;
UIKIT_EXTERN NSString *const kNotificationNewsValueName;
UIKIT_EXTERN NSString *const KunreadNum;
UIKIT_EXTERN NSString *const kNotificationStopTimer;
UIKIT_EXTERN NSString *const kNotificationStartTimer;
UIKIT_EXTERN NSString *const kNotificationDownloadH5Zip;

/************************* 下载 *************************/
UIKIT_EXTERN NSString * const HWDownloadProgressNotification;                   // 进度回调通知
UIKIT_EXTERN NSString * const HWDownloadStateChangeNotification;                // 状态改变通知
UIKIT_EXTERN NSString * const HWDownloadMaxConcurrentCountKey;                  // 最大同时下载数量key
UIKIT_EXTERN NSString * const HWDownloadMaxConcurrentCountChangeNotification;   // 最大同时下载数量改变通知
UIKIT_EXTERN NSString * const HWDownloadAllowsCellularAccessKey;                // 是否允许蜂窝网络下载key
UIKIT_EXTERN NSString * const HWDownloadAllowsCellularAccessChangeNotification; // 是否允许蜂窝网络下载改变通知

/************************* 网络 *************************/
UIKIT_EXTERN NSString * const HWNetworkingReachabilityDidChangeNotification;    // 网络改变改变通知


#pragma mark - 第三方信息

UIKIT_EXTERN NSString *const RYAPPKey;



