//
//  LCLoginController.m
//  MRLC
//
//  Created by DBB on 2017/8/11.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import "LCLoginController.h"
#import "SPInvitationCodeController.h"
#import "SGTabBarController.h"
#import "AppDelegate.h"
#import "SPTourisController.h"


@interface LCLoginController ()

@property (nonatomic,strong)UIView *fieleView;
@property (nonatomic,strong)UILabel *mobileLab;
@property (nonatomic,strong)UITextField *mobileField;
@property (nonatomic,strong)UIButton *codeBtn;

@property (nonatomic,strong)UIView *codeView;
@property (nonatomic,strong)UILabel *codeLab;
@property (nonatomic,strong)UITextField *passwordField;

@property (nonatomic,strong)UIButton *loginBtn;
@property (nonatomic,strong)UIButton *forgetBtn;

@property (nonatomic,strong)UILabel *readPrompt;//阅读
@property (nonatomic,strong)UIButton *readBtn;


@end

@implementation LCLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证码登录";
    [self.view addSubview:self.fieleView];
    [self.fieleView addSubview:self.mobileLab];
    [self.fieleView addSubview:self.codeBtn];
    [self.fieleView addSubview:self.mobileField];

    [self.view addSubview:self.codeView];
    [self.codeView addSubview:self.codeLab];
    [self.codeView addSubview:self.passwordField];

    
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.forgetBtn];

    [self.view addSubview:self.readPrompt];
    [self.view addSubview:self.readBtn];

    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"注册" target:self action:@selector(registerClick) Itemcolor:[UIColor whiteColor]];

    
}

- (UIView *)fieleView{
    if (_fieleView == nil) {
        _fieleView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 50)];
        _fieleView.backgroundColor = [UIColor whiteColor];
    }
    return _fieleView;
}

- (UILabel *)mobileLab{
    if (_mobileLab == nil) {
        _mobileLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 50)];
        _mobileLab.textColor = FirstWordColor;
//        _mobileLab.textAlignment = NSTextAlignmentCenter;
        _mobileLab.font = FONT(15);
        _mobileLab.text = @"手机号：";
    }
    return _mobileLab;
}

- (UITextField *)mobileField{
    if (_mobileField == nil) {
        _mobileField = [[UITextField alloc] initWithFrame:CGRectMake(Width(100), 0, kScreenWidth-220, 50)];
        _mobileField.font = FONT(14);
        _mobileField.placeholder = @"请输入您的手机号";
        [_mobileField setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_mobileField setValue:WordColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _mobileField;
}

- (UIButton *)codeBtn{
    if (_codeBtn == nil) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.frame = CGRectMake(self.view.right-120,5, 100, 40);
//        _codeBtn.layer.borderWidth = 1;
//        _codeBtn.layer.cornerRadius = 5;
//        _codeBtn.layer.borderColor = FirstWordColor.CGColor;
        [_codeBtn setTitleColor:FirstWordColor forState:UIControlStateNormal];
        WEAKSELF
        STRONGSELF
        [_codeBtn addTimerForVerifyWithInterval:60 start:^{
            [strongSelf getcode];
        } complete:^{
            [strongSelf.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            strongSelf.codeBtn.enabled   = YES;
        }];
        
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.layer.cornerRadius = 5;
        _codeBtn.titleLabel.font = FONT(15);
        _codeBtn.clipsToBounds = YES;
//        _codeBtn.backgroundColor = MyBackRed;
        
    }
    return _codeBtn;
}



- (UIView *)codeView{
    if (_codeView == nil) {
        _codeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.fieleView.bottom+1, kScreenWidth, 50)];
        _codeView.backgroundColor = [UIColor whiteColor];
    }
    return _codeView;
}


- (UILabel *)codeLab{
    if (_codeLab == nil) {
        _codeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 50)];
        _codeLab.text = @"验证码:";
        _codeLab.textColor = FirstWordColor;
//        _codeLab.textAlignment = NSTextAlignmentCenter;
        _codeLab.font = Font14;
    }
    return _codeLab;
}


- (UITextField *)passwordField{
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(Width(100),0,200, 50)];
        _passwordField.font = FONT(15);
        _passwordField.placeholder = @"请输入您的验证码";
        [_passwordField setValue:WordColor forKeyPath:@"_placeholderLabel.textColor"];
//        _passwordField.secureTextEntry = YES;
    }
    return _passwordField;
}


- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(20, self.codeView.bottom+50, kScreenWidth-40, 50);
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.clipsToBounds = YES;
        _loginBtn.backgroundColor = ThemeColor;
        [_loginBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginBtn;
}

- (UIButton *)forgetBtn{
    if (_forgetBtn == nil) {
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetBtn.frame = CGRectMake((kScreenWidth-250)/2, self.loginBtn.bottom+50, 250, 20);
        [_forgetBtn setTitle:@"世界很大，我想去看看" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font = FONT(15);
        [_forgetBtn addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _forgetBtn;
}


- (UILabel *)readPrompt{
    if (_readPrompt == nil) {
        _readPrompt = [[UILabel alloc] initWithFrame:CGRectMake(100, self.view.bottom-50-64-KIsiPhoneX-KsafeTabIPhonex, Width(86), 25)];
        _readPrompt.text = @"我已阅读并同意";
        _readPrompt.textColor = WordColor;
        _readPrompt.font =  FONT(Width(12));
    }
    return _readPrompt;
}
- (UIButton *)readBtn{
    if (_readBtn == nil) {
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _readBtn.frame = CGRectMake(self.readPrompt.right-5, self.readPrompt.top,80, 25);
        [_readBtn setTitle:@"《服务协议》" forState:UIControlStateNormal];
        [_readBtn setTitleColor:MyWordRed forState:UIControlStateNormal];
        _readBtn.clipsToBounds = YES;
        _readBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _readBtn.titleLabel.font = FONT(Width(12));
        _readBtn.backgroundColor = [UIColor clearColor];
        [_readBtn addTarget:self action:@selector(rednegotiate) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _readBtn;
}


// 登录
- (void)next{
    NSString *token = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJTSEEyNTYifQ.eyJpc3MiOiJhcHBXaXRoWWV0aCIsImlhdCI6MTU0NDE0NDc1NCwiZXhwIjoxNTQ0NzQ5NTU0LCJpZCI6OSwidHlwZSI6InBob25lIiwidmVyc2lvbiI6Mn0.c0122c1834404a9c89fc0c0c8e7219f594c176a0e803a12ac964b49dce3ed886";
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:token forKey:isLogin];
    [DBAccountInfo sharedInstance].token = token;
    [DBAccountInfo sharedInstance].islogin = YES;
    
    //登录跳转
    SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
    [UIApplication sharedApplication].statusBarHidden = NO;
    ptAppDelegate.window.rootViewController = sgTabBar ;
    
    /* 完整流程，请别删除
    if (self.mobileField.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入您的手机号"];
        return;
    }
    
    if (self.passwordField.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入您的验证码"];
        return;
    }

    NSDictionary *params = @{@"phone" : _mobileField.text,
                             @"captcha" : _passwordField.text,
                             @"type" : @"phone"
                             };
    
    [JDWNetworkHelper POST:SPURL_API_Login parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];

        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            //保存token
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            [userdef setObject:responseDic[@"data"][@"token"] forKey:isLogin];
            [DBAccountInfo sharedInstance].token = responseDic[@"data"][@"token"];
            [DBAccountInfo sharedInstance].islogin = YES;
            
            //登录跳转
            SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
            [UIApplication sharedApplication].statusBarHidden = NO;
            ptAppDelegate.window.rootViewController = sgTabBar ;
            
            
            
        }else{
            
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];

    }];
*/
}

// 游客
- (void)forget{
    SPTourisController *tourist = [[SPTourisController alloc] init];
    [self.navigationController pushViewController:tourist animated:YES];

}

- (void)setPasswordStr:(NSString *)passwordStr{
    if (_passwordStr != passwordStr) {
        _passwordStr = passwordStr;
        self.passwordField.text = _passwordStr;
    }
}


- (void)back{
//    if (self.iswelecome) {
        [self.navigationController popViewControllerAnimated:YES];
//    }
//    [self.navigationController popToViewController:[DBAccountInfo sharedInstance].backControl animated:YES];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)registerClick{
    SPInvitationCodeController *registerc = [[SPInvitationCodeController alloc] init];
    [self.navigationController pushViewController:registerc animated:YES];
    
}

- (void)rednegotiate{
    
    
}

- (void)getcode{
    
    NSDictionary *parsms = @{@"phone":self.mobileField.text,
                            @"type":@"2"};
    [JDWNetworkHelper POST:PTURL_API_SENDMSG parameters:parsms success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
    }];
}
@end
