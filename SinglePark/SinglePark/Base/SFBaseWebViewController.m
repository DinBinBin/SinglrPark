//
//  SFBaseWebViewController.m
//  SunfoBank
//
//  Created by chuan on 16/1/27.
//  Copyright © 2016年 www.sunfobank.com. All rights reserved.
//

#import "SFBaseWebViewController.h"

@interface SFBaseWebViewController ()<UIWebViewDelegate>
@property (nonatomic, copy) NSString *htmlStr;
@end

@implementation SFBaseWebViewController
- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)requestData {


//    [MBProgressHUD showLoadToView:self.view];
//    [JDWNetworkHelper POST:self.deatilURL parameters:nil success:^(id responseObject) {
//        [MBProgressHUD hideHUDForView:self.view];
//        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
//        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
//
//            [self.webView loadHTMLString:self.htmlStr baseURL:nil];
//
//
//        }else{
//            if ([responseDic[@"messages"] isKindOfClass: [NSNull class]]) {
//                [MBProgressHUD showAutoMessage:@"请求失败"];
//
//            }else{
//                [MBProgressHUD showAutoMessage:responseDic[@"messages"]];
//            }
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view];
//        [MBProgressHUD showAutoMessage:Networkerror];
//    }];
    NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.deatilURL]];
   [ self.webView loadRequest:quest];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createWebView];
    
    if (@available(iOS 11.0, *)) {

        self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
    }
    
    [self requestData];

}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -

- (void)createWebView
{
    [self.view addSubview:self.webView];
}

#pragma mark - Setter/Getter

- (void)setDeatilURL:(NSString *)deatilURL
{
    if (_deatilURL != deatilURL) {
        _deatilURL = [deatilURL copy];
    }
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor colorWithHexString:@"E8E8F1"];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        [self setCookie];
    }
    return _webView;
}

- (void)setCookie
{
    // 添加cookie，去掉H5中得导航栏
    NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:
                                [NSDictionary dictionaryWithObject:@"app=ipone"
                                                            forKey:@"Set-Cookie"]
                                                                      forURL:[NSURL URLWithString:BASE_HttpURL]];
    // app=iphone
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie
                                                       forURL:[NSURL URLWithString:BASE_HttpURL]
                                              mainDocumentURL:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [self showRuningMan];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self hideRuningMan];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error
{

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;
    
    if ([urlStr rangeOfString:@"/help/lineservice"].length) {

    }
    return YES;
}

#pragma mark - instance

+ (SFBaseWebViewController *)createWebView:(NSString *)deatilUrl title:(NSString *)title
{
    SFBaseWebViewController *vc = [[SFBaseWebViewController alloc] init];
    vc.deatilURL = deatilUrl;

    if (title != nil) {
        vc.title = title;
    }
    return vc;
}

+ (SFBaseWebViewController *)createWebView:(NSString *)deatilUrl
{
    return [self createWebView:deatilUrl title:nil];
}

@end
