//
//  SPProtectionController.m
//  SinglePark
//
//  Created by DBB on 2018/10/20.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPProtectionController.h"
#import "SPProtectionOptViewController.h"


@interface SPProtectionController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,assign)NSInteger selItem;

@end

@implementation SPProtectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料隐私保护";
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getdata];

}

- (void)getdata{
    self.titleArr = @[@"完全公开模式",@"仅有视频的用户可见",@"指定用户可见",@"仅自己可见"];
    
    [self.listTabView reloadData];
    
}
#pragma mark ----UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return    self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.font = Font16;
    cell.textLabel.textColor = FirstWordColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < 2) {
        NSInteger row = [DBAccountInfo sharedInstance].model.config_privacy - 1;
        
        if (indexPath.row == row) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:ImageNamed(@"chase")];
            imageView.frame = CGRectMake(0, 0, 20, 20);
            cell.accessoryView = imageView;
            
        }
    }

    if (indexPath.row == 2) {
        
        NSInteger row = [DBAccountInfo sharedInstance].model.config_privacy;
        
        if (row == 3 || row ==4) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:ImageNamed(@"chase")];
            imageView.frame = CGRectMake(0, 0, 20, 20);
            cell.accessoryView = imageView;
            
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.row == 3) {
        NSInteger row = [DBAccountInfo sharedInstance].model.config_privacy - 2;
        
        if (indexPath.row == row) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:ImageNamed(@"chase")];
            imageView.frame = CGRectMake(0, 0, 20, 20);
            cell.accessoryView = imageView;
            
        }
    }
    
    return cell;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [DBAccountInfo sharedInstance].model.config_privacy = indexPath.row + 1;
        [tableView reloadData];
    }else if (indexPath.row == 1) {
        [DBAccountInfo sharedInstance].model.config_privacy = indexPath.row + 1;
        [tableView reloadData];
    }else if (indexPath.row == 2) {
        SPProtectionOptViewController *vc = [[SPProtectionOptViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [DBAccountInfo sharedInstance].model.config_privacy = indexPath.row + 2;
        [tableView reloadData];
    }

}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (void)back {
    [super back];
    
    
    NSDictionary *parsms = @{
                             @"config_privacy":@([DBAccountInfo sharedInstance].model.config_privacy),

                             };
    WEAKSELF
    STRONGSELF
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:PTURL_API_UserChage parameters:parsms success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:strongSelf.view];
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            //            [MBProgressHUD showMessage:@"修改成功"];
        }else{
            [MBProgressHUD showAutoMessage:responseDic[@"messages"]];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:strongSelf.view];
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
    
    
}


- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        _listTabView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}


@end
