//
//  SPMineVC.m
//  SinglePark
//
//  Created by DBB on 2018/8/12.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPMineVC.h"
#import "SPMineHeadTabCell.h"
#import "SPMineCardController.h"
#import "SPSetController.h"
#import "SPPursuitController.h"
#import "SPEditPersonalInfoViewController.h"
#import "LCLoginController.h"


@interface SPMineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,strong)NSArray *imgArr;
@property (nonatomic, strong) SPPersonModel *model;

@end

@implementation SPMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.titleArr = @[@[@""],@[@"我的名片",@"追求的人"],@[@"设置"]];
    self.imgArr = @[@[@""],@[@"u2988",@"u2986"],@[@"u2984"]];
    
    [self requestData];


}

- (void)requestData {
    
    if (![DBAccountInfo sharedInstance].islogin) {
        LCLoginController *tourist = [[LCLoginController alloc] init];
        tourist.iswelecome = NO;
        [self.navigationController pushViewController:tourist animated:YES];
        return;
    }
    
    WEAKSELF
    STRONGSELF
    [JDWNetworkHelper POST:PTURL_API_UserGet parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            SPPersonModel *model = [SPPersonModel modelWithJSON:responseDic[@"data"]];
            strongSelf.model = model;
            
            //保存用户信息
            [[DBAccountInfo sharedInstance].model yy_modelSetWithJSON:responseDic[@"data"]];
            [JDWUserInfoDB saveUserInfo:[DBAccountInfo sharedInstance].model];
            
            [strongSelf.listTabView reloadData];
            
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
}
#pragma mark ----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.titleArr[section];
    return arr.count;
    
    //    if (section == 0) {
    //        return 1;
    //    }else if (section == 1){
    //        return 7;
    //    }else if (section == 2){
    //        return 4;
    //    }
    //    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.titleArr[indexPath.section];
    NSArray *imgarr = self.imgArr[indexPath.section];
    
    if (indexPath.section == 0) {
        SPMineHeadTabCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.coverStr forIndexPath:indexPath];
        cell.model =  self.model;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.font = FONT(16);
        cell.textLabel.textColor = FirstWordColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:imgarr[indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.row < arr.count-1) {
            return cell;
            
        }
        return cell;

    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.font = FONT(16);
        cell.textLabel.textColor = FirstWordColor;
        cell.imageView.image = [UIImage imageNamed:imgarr[indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 ) {
         SPEditPersonalInfoViewController *business = [[SPEditPersonalInfoViewController alloc] init];
        WEAKSELF
        STRONGSELF
        business.backRequsetBlock = ^{
            [strongSelf requestData];
        };
        [self.navigationController  pushViewController:business animated:YES];

    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            SPMineCardController *business = [[SPMineCardController alloc] init];
            business.model = self.model;
            [self.navigationController  pushViewController:business animated:YES];

        }else{
            SPPursuitController *business = [[SPPursuitController alloc] init];
            [self.navigationController  pushViewController:business animated:YES];

        }
    }else{
        SPSetController *business = [[SPSetController alloc] init];
        [self.navigationController  pushViewController:business animated:YES];
    }
    

}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}


- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        self.coverStr = @"coverStrhead";
        _listTabView.tableFooterView = [[UIView alloc] init];
        [_listTabView registerClass:[SPMineHeadTabCell class] forCellReuseIdentifier:self.coverStr];
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}



@end
