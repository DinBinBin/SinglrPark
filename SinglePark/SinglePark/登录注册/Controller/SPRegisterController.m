//
//  SPRegisterController.m
//  SinglePark
//
//  Created by DBB on 2018/8/28.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPRegisterController.h"
#import "SPPerfectController.h"

@interface SPRegisterController ()
@property (nonatomic,strong)UIView *fieleView;
@property (nonatomic,strong)UILabel *mobileLab;
@property (nonatomic,strong)UITextField *mobileField;
@property (nonatomic,strong)UIButton *codeBtn;

@property (nonatomic,strong)UIView *codeView;
@property (nonatomic,strong)UILabel *codeLab;
@property (nonatomic,strong)UITextField *passwordField;
@property (nonatomic,strong)UIButton *registerBtn;

@property (nonatomic,strong)UILabel *readPrompt;//阅读
@property (nonatomic,strong)UIButton *readBtn;

@end

@implementation SPRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机号注册";
    [self.view addSubview:self.fieleView];
    [self.fieleView addSubview:self.mobileLab];
    [self.fieleView addSubview:self.codeBtn];
    [self.fieleView addSubview:self.mobileField];
    
    [self.view addSubview:self.codeView];
    [self.codeView addSubview:self.codeLab];
    [self.codeView addSubview:self.passwordField];
    [self.view addSubview:self.registerBtn];
    
    [self.view addSubview:self.readPrompt];
    [self.view addSubview:self.readBtn];
    
    
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
        _mobileField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth-220, 50)];
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
            if ([strongSelf.mobileField.text isValidateRegularExpressionWithType:VRETypePhoneNumber]) { //判断是否为电话号码
                NSDictionary *parsms = @{@"phone":strongSelf.mobileField.text,
                                         @"type":@"1"};
                [JDWNetworkHelper POST:PTURL_API_SENDMSG parameters:parsms success:^(id responseObject) {
                    NSDictionary *responseDic = (NSDictionary *)responseObject;
                    if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
                        
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD showAutoMessage:Networkerror];
                    strongSelf.codeBtn.enabled = YES;
                }];
            }else{
                strongSelf.codeBtn.enabled = YES;
                [MBProgressHUD showAutoMessage:MobileFalse];
            }
        } complete:^{
            [strongSelf.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            strongSelf.codeBtn.enabled   = YES;
        }];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.layer.cornerRadius = 5;
        _codeBtn.titleLabel.font = FONT(15);
        _codeBtn.clipsToBounds = YES;
        
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
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(100,0,200, 50)];
        _passwordField.font = FONT(15);
        _passwordField.placeholder = @"请输入您的登录密码";
        [_passwordField setValue:WordColor forKeyPath:@"_placeholderLabel.textColor"];
//        _passwordField.secureTextEntry = YES;
    }
    return _passwordField;
}


- (UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.frame = CGRectMake(20, self.codeView.bottom+50, kScreenWidth-40, 50);
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerBtn.layer.cornerRadius = 5;
        _registerBtn.clipsToBounds = YES;
        _registerBtn.backgroundColor = ThemeColor;
        [_registerBtn addTarget:self action:@selector(registerclick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registerBtn;
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

- (void)rednegotiate{
    
}

- (void)registerclick{
    SPPerfectController *perfect = [[SPPerfectController alloc] init];
    [self.navigationController pushViewController:perfect animated:YES];

//    NSDictionary *parsms = @{@"phone":self.mobileField.text,
//                             @"captcha":self.passwordField.text,
//                             @"type":@"phone"};
//    [JDWNetworkHelper POST:PTURL_API_LOGINREGIST parameters:parsms success:^(id responseObject) {
//        NSDictionary *responseDic = (NSDictionary *)responseObject;
//        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
//
//            DBAccountInfo *account = [DBAccountInfo sharedInstance];
//            account.model = [[SPPersonModel alloc] initWithDataDic:responseDic[@"data"]];
//            [JDWUserInfoDB saveUserInfo:account.model];
//            SPPerfectController *perfect = [[SPPerfectController alloc] init];
//            [self.navigationController pushViewController:perfect animated:YES];
//        }else{
//            if ([responseDic[@"messages"] isKindOfClass: [NSNull class]]) {
//                [MBProgressHUD showAutoMessage:@"请求失败"];
//
//            }else{
//                [MBProgressHUD showAutoMessage:responseDic[@"messages"]];
//            }
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showAutoMessage:Networkerror];
//    }];
    
}


@end
