//
//  SPInvitationCodeController.m
//  SinglePark
//
//  Created by DBB on 2018/9/12.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPInvitationCodeController.h"
#import "SPRegisterController.h"

@interface SPInvitationCodeController ()
@property (nonatomic,strong)UIView *invitationView;
@property (nonatomic,strong)UILabel *invitationLab;
@property (nonatomic,strong)UITextField *invitationField;
@property (nonatomic,strong)UIButton *nextBtn;
@property (nonatomic,strong)UILabel *negotiateLab;
@property (nonatomic,strong)UILabel *readPrompt;//阅读
@property (nonatomic,strong)UIButton *readBtn;

@end

@implementation SPInvitationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"请输入邀请码";
    [self.view addSubview:self.invitationView];
    [self.invitationView addSubview:self.invitationLab];
    [self.invitationView addSubview:self.invitationField];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.negotiateLab];
    [self.view addSubview:self.readPrompt];
    [self.view addSubview:self.readBtn];
    
    
}

- (UIView *)invitationView{
    if (_invitationView == nil) {
        _invitationView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 50)];
        _invitationView.backgroundColor = [UIColor whiteColor];
    }
    return _invitationView;
}


- (UILabel *)invitationLab{
    if (_invitationLab == nil) {
        _invitationLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 50)];
        _invitationLab.text = @"邀请码:";
        _invitationLab.textColor = FirstWordColor;
        //        _codeLab.textAlignment = NSTextAlignmentCenter;
        _invitationLab.font = Font14;
    }
    return _invitationLab;
}


- (UITextField *)invitationField{
    if (_invitationField == nil) {
        _invitationField = [[UITextField alloc] initWithFrame:CGRectMake(100,0,200, 50)];
        _invitationField.font = FONT(15);
        _invitationField.placeholder = @"请输入邀请码";
        [_invitationField setValue:WordColor forKeyPath:@"_placeholderLabel.textColor"];
//        _invitationField.secureTextEntry = YES;
    }
    return _invitationField;
}

- (UIButton *)nextBtn{
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(20, self.invitationView.bottom+80, kScreenWidth-40, 50);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.clipsToBounds = YES;
        _nextBtn.backgroundColor = ThemeColor;
        [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextBtn;
}

- (UILabel *)negotiateLab{
    if (_negotiateLab == nil) {
        _negotiateLab = [[UILabel alloc] initWithFrame:CGRectMake(20,self.nextBtn.bottom+50, kScreenWidth-40, 100)];
        _negotiateLab.text = @"【说明】\n1.注册时必须有邀请码方可注册。\n2.邀请码来自“单身公园”官方，如需邀请码的朋友请关注单身公园微信公众号“单身公园APP”（ID：YeahotAPP）";
        _negotiateLab.numberOfLines = 0;
        _negotiateLab.textColor = TextMianColor;
        _negotiateLab.font =  FONT(Width(14));
    }
    return _negotiateLab;
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
        _readBtn.frame = CGRectMake(self.readPrompt.right-5, self.readPrompt.top,100, 25);
        [_readBtn setTitle:@"《服务协议》" forState:UIControlStateNormal];
        [_readBtn setTitleColor:MyWordRed forState:UIControlStateNormal];
        _readBtn.clipsToBounds = YES;
        _readBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _readBtn.titleLabel.font = FONT(Width(12));
        _readBtn.backgroundColor = [UIColor clearColor];
        [_readBtn addTarget:self action:@selector(rednegotiate) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _readBtn;
}

- (void)next{
//            SPRegisterController *registerc = [[SPRegisterController alloc] init];
//            [self.navigationController pushViewController:registerc animated:YES];
    
    if (self.invitationField.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入邀请码"];
        return;
    }
    NSDictionary *parsms = @{@"code":self.invitationField.text,
                             @"type":@"2"};
    [JDWNetworkHelper POST:PTURLinvitation parameters:parsms success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            SPRegisterController *registerc = [[SPRegisterController alloc] init];
            [self.navigationController pushViewController:registerc animated:YES];
        }else{
            [MBProgressHUD showAutoMessage:responseDic[@"messages"]];
        }


    } failure:^(NSError *error) {
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
    
}


- (void)rednegotiate{

}

@end
