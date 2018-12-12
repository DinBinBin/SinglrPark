//
//  SPSupplementController.m
//  SinglePark
//
//  Created by DBB on 2018/9/13.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPSupplementController.h"
#import "SGTabBarController.h"
#import "AppDelegate.h"
#import "SPAreaViewController.h"
#import "SPEditSectionViewController.h"
#import "MFDatePickView.h"


@interface SPSupplementController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SPSelectDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)UITableView *perfectTabView;
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UITextField *ageField;
@property (nonatomic,strong)UITextField *occupationField;
@property (nonatomic,strong)UITextField *regionField;

@property (nonatomic,strong)UIButton *nextStepBtn;
@property (nonatomic,strong)UILabel *promptLab;

/** 添加遮罩 */
@property (nonatomic, strong) UIView *alertBackgroundView;
@end

@implementation SPSupplementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善基本信息";
    [self.view addSubview:self.perfectTabView];
    [self getuserinfo];
    
    
    [self.perfectTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

- (UITableView *)perfectTabView{
    if (_perfectTabView == nil) {
        _perfectTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64)];
        _perfectTabView.delegate  = self;
        _perfectTabView.dataSource = self;
        _perfectTabView.backgroundColor = PTBackColor;
        _perfectTabView.tableFooterView = [[UIView alloc] init];
    }
    return _perfectTabView;
}

- (UIButton *)headBtn{
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headBtn.frame = CGRectMake(self.view.right-120,5, 100, 40);
        
        
    }
    return _headBtn;
}

- (UILabel *)promptLab{
    if (_promptLab == nil) {
        _promptLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 50)];
        _promptLab.textColor = FirstWordColor;
        //        _mobileLab.textAlignment = NSTextAlignmentCenter;
        _promptLab.font = FONT(14);
        _promptLab.text = @"注意：性别选择后不能更改！";
    }
    return _promptLab;
}

- (UITextField *)ageField{
    if (_ageField == nil) {
        _ageField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth-220, 50)];
        _ageField.font = FONT(14);
        _ageField.placeholder = @"请输入您的生日日期";
        [_ageField setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_ageField setValue:WordColor forKeyPath:@"_placeholderLabel.textColor"];
        _ageField.delegate = self;
        [self setupDatePick];

    }
    return _ageField;
}

- (UITextField *)occupationField{
    if (_occupationField == nil) {
        _occupationField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth-220, 50)];
        _occupationField.font = FONT(15);
        _occupationField.placeholder = @"请输入您的职业";
        _occupationField.delegate = self;
        [_occupationField setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_occupationField setValue:WordColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _occupationField;

}
- (UITextField *)regionField{
    if (_regionField == nil) {
        _regionField = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, kScreenWidth-220, 50)];
        _regionField.font = FONT(15);
        _regionField.placeholder = @"请输入您的地区";
        _regionField.delegate = self;
        [_regionField setValue:FONT(14) forKeyPath:@"_placeholderLabel.font"];
        [_regionField setValue:WordColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _regionField;
}
- (UIButton *)nextStepBtn{
    if (_nextStepBtn == nil) {
        _nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepBtn.layer.cornerRadius = 5;
        _nextStepBtn.clipsToBounds = YES;
        _nextStepBtn.backgroundColor = ThemeColor;
        [_nextStepBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepBtn;
}



#pragma mark - Tab delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 50;
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.headBtn];
        [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView).offset(10);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
            make.width.height.mas_equalTo(Width(80));
        }];
        self.headBtn.layer.cornerRadius = Width(80)/2;
        self.headBtn.layer.masksToBounds = YES;
        [self.headBtn setImage:self.img forState:UIControlStateNormal];
        
    }else if (indexPath.section == 1){
        UILabel *promptcellLab = [[UILabel alloc] init];
        [cell.contentView addSubview:promptcellLab];
        promptcellLab.textColor = FirstWordColor;
        promptcellLab.font = FONT(14);
        [promptcellLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(10);
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        if (indexPath.row == 0) {
            promptcellLab.text = @"生日：";
            [cell.contentView addSubview:self.ageField];
            [self.ageField   mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(promptcellLab.mas_right).offset(10);
                make.top.equalTo(promptcellLab);
                make.bottom.equalTo(promptcellLab.mas_bottom);
            }];
            
        }else if(indexPath.row == 1){
            promptcellLab.text = @"职业：";
            [cell.contentView addSubview:self.occupationField];
            [self.occupationField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(promptcellLab.mas_right).offset(10);
                make.top.equalTo(promptcellLab);
                make.bottom.equalTo(promptcellLab.mas_bottom);
            }];
            
          
        }else{
            promptcellLab.text = @"地区：";
           
            
            [cell.contentView addSubview:self.regionField];
            [self.regionField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(promptcellLab.mas_right).offset(10);
                make.top.equalTo(promptcellLab);
                make.bottom.equalTo(promptcellLab.mas_bottom);
            }];
            
        }
        
    }else{
        [cell.contentView addSubview:self.promptLab];
        [self.promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(20);
            make.top.equalTo(cell.contentView.mas_top).offset(15);
            
        }];
        
        [cell.contentView addSubview:self.nextStepBtn];
        [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.promptLab);
            make.top.equalTo(self.promptLab.mas_bottom).offset(15);
            make.right.equalTo(cell.contentView.mas_right).offset(-20);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
        }];
        
        
    }
    
    
    return cell;
}

#pragma mark - SPSelectDelegate


#pragma mark - SPJobDelegate
- (void)selectAreaName:(NSString *)areaName {
    self.regionField.text = areaName;
}
#pragma mark - 时间选择器
-(void)setupDatePick{
    
    
    
    MFDatePickView *datePickView = [[MFDatePickView alloc]initWithFrame:CGRectMake(0, 408, kScreenW, 216 + 44)];
    datePickView.pickType = MFDatePick;
    datePickView.cancelBtnDidClickBlock = ^(){
        
        [self.ageField resignFirstResponder];
        [self.alertBackgroundView removeFromSuperview];

    };
    datePickView.doneBtnDidClickBlock = ^(NSString *str){
        
        [self.ageField resignFirstResponder];
        [self.alertBackgroundView removeFromSuperview];
        self.ageField.text = str;
        
    };
    datePickView.selectDateBlock = ^(NSDate *date){
        
        //把当前的日期给文本框赋值
        //获取当前选中的日期
        
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        
        self.ageField.text = [fmt stringFromDate:date];;
        
    };
    //日期键盘
    self.ageField.inputView = datePickView;
    
}


//点击遮罩
-(void)tap{
    
    [self.ageField resignFirstResponder];
    [self.alertBackgroundView removeFromSuperview];
}

#pragma mark - textField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.occupationField) {
        SPEditSectionViewController *vc = [[SPEditSectionViewController alloc] init];
        vc.type = SPJobEditType;
        WEAKSELF
        vc.SPCallBackStringBlock = ^(NSString * _Nonnull str) {
            STRONGSELF
            strongSelf.occupationField.text = str;
        };
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }else if (textField == self.regionField) {
        SPAreaViewController *vc = [[SPAreaViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (textField == self.ageField) {
        WEAKSELF
        STRONGSELF
        UIView  *alertBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        self.alertBackgroundView = alertBackgroundView;
        alertBackgroundView.backgroundColor = UIColorFromHEX(0x000000, 0.5);
        [[UIApplication sharedApplication].keyWindow addSubview:alertBackgroundView];
        alertBackgroundView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            strongSelf.alertBackgroundView.alpha = 1;
        }];
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        
        tap.delegate = self;
        
        //2.添加手势
        [self.alertBackgroundView addGestureRecognizer:tap];
        
        
    }
}




#pragma mark - click
- (void)finishClick {
    NSDictionary *parsms = @{
                             @"nick_name":self.nickName,
                             @"sex":@(self.sex),
                             @"birthday":self.ageField.text,
                             @"job":@[self.occupationField.text],
                             };
    WEAKSELF
    STRONGSELF
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:PTURL_API_UserChage parameters:parsms success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:strongSelf.view];
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            //登录跳转
            SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
            [UIApplication sharedApplication].statusBarHidden = NO;
            ptAppDelegate.window.rootViewController = sgTabBar ;
        }else{
            [MBProgressHUD showAutoMessage:responseDic[@"messages"]];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:strongSelf.view];
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
}

- (void)rednegotiate{

}


- (void)getuserinfo{
    [JDWNetworkHelper POST:PTURL_API_UserGet parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [[DBAccountInfo sharedInstance].model yy_modelSetWithJSON:responseDic[@"data"]];
            [JDWUserInfoDB saveUserInfo:[DBAccountInfo sharedInstance].model];
        }else{
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
}
@end
