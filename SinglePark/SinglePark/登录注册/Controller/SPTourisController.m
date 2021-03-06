//
//  SPTourisController.m
//  SinglePark
//
//  Created by DBB on 2018/8/28.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPTourisController.h"
#import "SPInvitationCodeController.h"
#import "SGTabBarController.h"
#import "AppDelegate.h"
#import "SPRegisterController.h"

@interface SPTourisController ()
@property (nonatomic,strong)UIView *fieleView;
@property (nonatomic,strong)UILabel *passwordLab;
@property (nonatomic,strong)UITextField *passwordField;
@property (nonatomic,strong)UIButton *nextBtn;

@end

@implementation SPTourisController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请输入密码";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"注册" target:self action:@selector(registerClick) Itemcolor:[UIColor whiteColor]];
    
    [self.view addSubview:self.fieleView];
    [self.fieleView addSubview:self.passwordField];
    [self.fieleView addSubview:self.passwordLab];
    [self.view addSubview:self.nextBtn];
    
}

- (UIView *)fieleView{
    if (_fieleView == nil) {
        _fieleView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 50)];
        _fieleView.backgroundColor = [UIColor whiteColor];
    }
    return _fieleView;
}

- (UILabel *)passwordLab{
    if (_passwordLab == nil) {
        _passwordLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 50)];
        _passwordLab.text = @"密码：";
        _passwordLab.textColor = FirstWordColor;
        _passwordLab.font = FONT(14);
    }
    return _passwordLab;
}

- (UITextField *)passwordField{
    if (_passwordField == nil) {
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(100,0, kScreenWidth-120, 50)];
        _passwordField.font = FONT(15);
        
        _passwordField.placeholder = @"请输入您的登录密码";
        [_passwordField setValue:WordColor forKeyPath:@"_placeholderLabel.textColor"];
        
//        _passwordField.secureTextEntry = YES;
    }
    return _passwordField;
}

- (UIButton *)nextBtn{
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(20, self.fieleView.bottom+50, kScreenWidth-40, 50);
        [_nextBtn setTitle:@"进入" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.clipsToBounds = YES;
        _nextBtn.backgroundColor = ThemeColor;
        [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextBtn;
}

- (void)next{

//    SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    ptAppDelegate.window.rootViewController = sgTabBar ;
    
    if (self.passwordField.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入邀请码"];
        return;
    }
    NSDictionary *parsms = @{@"code":self.passwordField.text,
                             @"type":@"2"};
    [JDWNetworkHelper POST:PTURLinvitation parameters:parsms success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            
            [ND setObject:@"" forKey:isLogin];
            [DBAccountInfo sharedInstance].islogin = NO;
            [DBAccountInfo sharedInstance].isTouris = YES;

            SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
            [UIApplication sharedApplication].statusBarHidden = NO;
            ptAppDelegate.window.rootViewController = sgTabBar ;
        }else{
            [MBProgressHUD showAutoMessage:responseDic[@"messages"]];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
    

}


- (void)registerClick{
    [JDWNetworkHelper POST:PTURLinvitationOffer parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            if ([responseDic[@"data"][@"is_register_on"] isEqualToString:@"on"]) {
                SPInvitationCodeController *registerc = [[SPInvitationCodeController alloc] init];
                [self.navigationController pushViewController:registerc animated:YES];
            }else{
                SPRegisterController *registerc = [[SPRegisterController alloc] init];
                [self.navigationController pushViewController:registerc animated:YES];
            }
        }else{
            SPRegisterController *registerc = [[SPRegisterController alloc] init];
            [self.navigationController pushViewController:registerc animated:YES];
        }
        
    } failure:^(NSError *error) {
        SPRegisterController *registerc = [[SPRegisterController alloc] init];
        [self.navigationController pushViewController:registerc animated:YES];
    }];}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
