//
//  SPWelcomeController.m
//  SinglePark
//
//  Created by DBB on 2018/8/28.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPWelcomeController.h"
#import "LCLoginController.h"
#import "SPTourisController.h"
#import "SPInvitationCodeController.h"
#import "SPRegisterController.h"



@interface SPWelcomeController ()<UINavigationControllerDelegate>

@property (nonatomic,strong)UIImageView *backImgView;
//@property (nonatomic,strong)UIButton *touristBtn;
@property (nonatomic,strong)UIButton *registerBtn;
@property (nonatomic,strong)UIButton *loginBtn;


@end

@implementation SPWelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backImgView];
//    [self.backImgView addSubview:self.touristBtn];
    [self.backImgView addSubview:self.registerBtn];
    [self.backImgView addSubview:self.loginBtn];
    self.navigationController.delegate = self;

    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kScreenHeight);
        make.top.left.right.equalTo(self.view);

    }];
    
//    [self.touristBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.backImgView.mas_bottom).offset(-Height(25)-KsafeTabIPhonex);
//        make.left.mas_equalTo(25);
//        make.right.equalTo(self.backImgView.mas_right).offset(-Height(25));
//        make.height.mas_equalTo(44);
//    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backImgView.mas_bottom).offset(-Height(25)-Height(25)-KsafeTabIPhonex);
        make.left.mas_equalTo(25);
        make.right.equalTo(self.backImgView.mas_right).offset(-Height(25));
        make.height.mas_equalTo(44);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.registerBtn.mas_top).offset(-Height(25));
        make.left.mas_equalTo(25);
        make.right.equalTo(self.backImgView.mas_right).offset(-Height(25));
        make.height.mas_equalTo(44);
    }];
}

- (UIImageView *)backImgView{
    if (_backImgView == nil) {
        _backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"欢迎页new"]];
        _backImgView.userInteractionEnabled = YES;
    }
    return _backImgView;
}

//- (UIButton *)touristBtn{
//    if (_touristBtn == nil) {
//        _touristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////        _touristBtn.backgroundColor = [UIColor whiteColor];
//        [_touristBtn setTitle:@"游客进入" forState:UIControlStateNormal];
//        [_touristBtn addTarget:self action:@selector(touristClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _touristBtn;
//}

- (UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.backgroundColor = [UIColor whiteColor];
        [_registerBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = [UIColor whiteColor];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (void)touristClick{
    SPTourisController *tourist = [[SPTourisController alloc] init];
    [self.navigationController pushViewController:tourist animated:YES];
}

// 跳转到注册页面
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
    }];
}

- (void)loginClick{
    LCLoginController *tourist = [[LCLoginController alloc] init];
    tourist.iswelecome = YES;
    [self.navigationController pushViewController:tourist animated:YES];
}


#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

@end




