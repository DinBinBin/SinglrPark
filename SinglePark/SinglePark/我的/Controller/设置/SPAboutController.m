//
//  SPAboutController.m
//  SinglePark
//
//  Created by DBB on 2018/10/20.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPAboutController.h"
#import "SFBaseWebViewController.h"

@interface SPAboutController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic, copy) NSString *version;
@end

@implementation SPAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于单身公园";
    
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getdata];
    
    [self getVersion:NO];
}

- (void)getdata{
    self.titleArr = @[@"去评分",@"用户协议",@"关于/联系我们",@"当前版本"];

    [self.listTabView reloadData];
    
}

- (void)getVersion:(BOOL)isClickCell {
    
    NSDictionary *param = @{@"type":@"1"};
    [JDWNetworkHelper POST:SPVersion parameters:param success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSDictionary *data = responseDic[@"data"];
            if (![data objectForKey:@"status"]) {
                NSString *verson = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                self.version = [NSString stringWithFormat:@"已是最新版本：V%@",verson];
                
                if (isClickCell) {
                    [MBProgressHUD showMessage:@"已是最新版本"];
                }
                
            }else{
                
                self.version = [NSString stringWithFormat:@"发现新版本：V%@",responseDic[@"data"][@"version"]];
                
                if (isClickCell) {
                    int status = [responseDic[@"data"][@"status"] intValue];
                    if (status == 1) { //选更
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:responseDic[@"data"][@"intro"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                        alertView.tag = 1001;
                        [alertView show];
                    }else if (status == 2){//强更
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:responseDic[@"data"][@"intro"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        alertView.tag = 1002;
                        [alertView show];
                    }
                }
                

            }
            
            [self.listTabView reloadData];
        
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        
        if (buttonIndex == 1) {
            
        }
        
    }else if (alertView.tag == 1002) {
        
        
    }
}

#pragma mark ----UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.font = Font16;
    cell.textLabel.textColor = FirstWordColor;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (indexPath.row == 0) {
        
        return cell;
    }else if (indexPath.row == 1) {
        
        
        return cell;
    }else if (indexPath.row == 2) {
        return cell;
    }else if (indexPath.row == 3) {
        
        cell.detailTextLabel.text = self.version;
        
        return cell;

    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.width = kScreenWidth;
        return cell;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        NSString *url = [SPURL_API_Document stringByAppendingPathComponent:@"2"];
        SFBaseWebViewController *webViewVC = [SFBaseWebViewController createWebView:SPURL_protocol title:@"用户协议"];
        [self.navigationController pushViewController:webViewVC animated:YES];
    }else if (indexPath.row == 3) {
        [self getVersion:YES];
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
        _listTabView.tableFooterView = [[UIView alloc] init];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
        UIView *customerView = [[[NSBundle mainBundle] loadNibNamed:@"SPCurrencyHeaderView" owner:nil options:nil] firstObject];
        customerView.backgroundColor = PTBackColor;
        [headerView addSubview:customerView];
        [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(headerView);
        }];
        _listTabView.tableHeaderView = headerView;
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}



@end
