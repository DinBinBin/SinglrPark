//
//  SFBaseWebViewController.h
//  SunfoBank
//
//  Created by chuan on 16/1/27.
//  Copyright © 2016年 www.sunfobank.com. All rights reserved.
//

#import "SGBaseController.h"

@interface SFBaseWebViewController : SGBaseController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *deatilURL;

+ (SFBaseWebViewController *)createWebView:(NSString *)deatilUrl title:(NSString *)title;
+ (SFBaseWebViewController *)createWebView:(NSString *)deatilUrl;

@end
