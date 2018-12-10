//
//  Common_Style.h
//  WoBo
//
//  Created by gongyouqiang on 15/11/16.
//  Copyright © 2015年 5bvv. All rights reserved.
//

#ifndef Common_Style_h
#define Common_Style_h

#define klimitNumbers     @"0123456789"
#define MobileFalse     @"手机号格式不正确"
#define Mobilenull     @"请输入手机号"
#define Networkerror     @"网络连接错误"
#define Dissimilarity     @"确认密码与密码不一致"
#define Passworderror     @"请输入6~12位的数字、字母区分大小写"
#define CodeSend         @"验证码已发送"
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define KAddIPhonex (KIsiPhoneX?24:0)
#define KsafeTabIPhonex (KIsiPhoneX?34:0)
#define JDWLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define kSFTimeoutInterval 30.0f
#define ND [NSUserDefaults standardUserDefaults]
#define KEYWINDOW       [UIApplication sharedApplication].keyWindow

// 提示符时间长度
#define kHUDTime 2.5

/// 字符输入限制
#define Height(h)       h*kScreenHeight/667
#define Width(w)        w*kScreenWidth/375
#define isLogin          @"isLogin"

#define klimitNumbers     @"0123456789"
#define xX          @"xX"
#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#define Special_Character  @"[-/:\\;()$&@.,?!'\"{}#%^*+=_|~<>£¥€•]-：；（）¥@“”。，、？！.【】｛｝#%^*+=_—|～《》$&•…,^_^?!'"

#define SpecialCharacterAndNumber @"[-/:\\;()$&@.,?!'\"{}#%^*+=_|~<>£¥€•]-：；（）¥@“”。，、？！.【】｛｝#%^*+=_—|～《》$&•…,^_^?!'0123456789"

#define AllCharacterAndNumber @"[-/:\\;()$&@.,?!'\"{}#%^*+=_|~<>£¥€•]-：；（）¥@“”。，、？！.【】｛｝#%^*+=_—|～《》$&•…,^_^?!'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

/// 设置颜色 示例：UIColorHex(0x26A7E8)
#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define isIPhoneXAll ([[UIApplication sharedApplication] statusBarFrame].size.height == 44)

#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kNavigationHeight (isIPhoneXAll ? 88.f : 64.f) // 导航栏高度
#define kStatusBarHeight (isIPhoneXAll ? 44.f : 20.f) //状态栏高度
#define kTabbarHeight (isIPhoneXAll ? (49.f+34.f) : 49.f) // tabBar高度
#define kIndicatorH (isIPhoneXAll ? 34.f : 0.f)  // home indicator高度

#define ptAppDelegate        ((AppDelegate*)[[UIApplication sharedApplication]delegate])

//#define BASE_HttpURL      @"http://sonxy.free.ngrok.cc"  //base 地址
#define BASE_HttpURL      @"http://jiu.wuchenge.com/api/v1"  //base 地址

#define FONT(a)          [UIFont systemFontOfSize:(a)]

/// 灰色—如内容字体颜色
#define kColorLightgrayContent UIColorHex(0x969696)
// 系统版本
#define wbSystemVersion   ([[[UIDevice currentDevice] systemVersion] floatValue])
// 强弱引用
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;
// 通过key，获取数组或字典Value
#define GetObjectFromDicWithKey(dictonary, key , Class) ({\
NSDictionary *xxooxx = TTDynamicCast(NSDictionary, dictonary);\
id value = [[xxooxx objectForKey:key] isKindOfClass:[Class class]] ? [xxooxx objectForKey:key] : nil;\
value;\
})

#define kDocumentDirectoryPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#define WBNSNumberWithString(A)   @([A integerValue])

//颜色宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
/** 用于 标题，重要颜色 */
#define TextMianColor           HexCOLOR(0x666666)
/** RGB 颜色转换（16进制->10进制）*/
#define HexCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** DEFINE IMAGE      定义UIImage对象 */
#define ImageNamed(imageName) [UIImage imageNamed:imageName]
/** 用于 主题颜色 */
#define ThemeColor              HexCOLOR(0x9900CC)
/** 用于 次要文字颜色 */
#define TextSecondaryColor      HexCOLOR(0x676767)
/** 用于 第一种文字 */
#define FirstWordColor      HexCOLOR(0x333333)
/** 用于 第二种文字 */
#define SecondWordColor      HexCOLOR(0x999999)
/** 用于 字体12 */
#define Font16              FONT(16)
/** 用于 字体14 */
#define Font14              FONT(14)
/** 用于 背景红*/
#define MyBackground              HexCOLOR(0xf2f2f2)
/** 用于 字体红*/
#define MyWordRed              HexCOLOR(0xf9742a)
/** 用于 输入框提示 */
#define WordColor      HexCOLOR(0xa1acb4)

/** 用于 线条颜色*/
#define MyBackLine              HexCOLOR(0xedddddd)
/** 用于 按钮大小 */
#define BtnMiddleFloat      40


#pragma mark --- 头文字
/** 用于 背景蓝色 */
#define PTBackBlue              HexCOLOR(0x2583ca)
/** 用于 背景颜色 */
#define PTBackColor              HexCOLOR(0xf3f3f3)
#define PTLog(...) NSLog(__VA_ARGS__)

/** RGB 颜色转换带透明度（16进制->10进制）*/
#define UIColorFromHEX(hexValue, alphaValue) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:alphaValue]
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}

#endif /* Common_Style_h */
