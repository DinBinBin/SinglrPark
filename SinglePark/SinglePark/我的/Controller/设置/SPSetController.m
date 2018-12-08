//
//  SPSetController.m
//  SinglePark
//
//  Created by DBB on 2018/10/14.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPSetController.h"
#import "JDWFillEditController.h"
#import "SPAboutController.h"
#import "SPAcceptNoticeController.h"
#import "SPCurrencyController.h"
#import "SPPrivacyController.h"
#import "SGNavigationController.h"
#import "SPWelcomeController.h"

@interface SPSetController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,strong)NSArray *titleArr;

@end

@implementation SPSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getdata];
}

- (void)getdata{
    self.titleArr = @[@[@"账号信息"],@[@"新消息通知",@"隐私",@"通用"],@[@"意见反馈",@"关于单身公园"],@[@"退出登录"]];
  
    [self.listTabView reloadData];
    
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.font = Font16;
    cell.textLabel.textColor = FirstWordColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = @"151159124124";
        return cell;
    }else if (indexPath.section == 1) {
        
     
        return cell;
    }else if (indexPath.section == 2) {
        return cell;

    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.width = kScreenWidth;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {   //新消息
            SPAcceptNoticeController *controller = [[SPAcceptNoticeController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 1){  //隐私
            SPPrivacyController *controller = [[SPPrivacyController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];

        }else if (indexPath.row == 2){  //通用
            SPCurrencyController *controller = [[SPCurrencyController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];

        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {   //意见反馈
            JDWFillEditController *controller = [[JDWFillEditController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];

        }else{      //关于
            SPAboutController *controller = [[SPAboutController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];

        }
    }else if (indexPath.section == 3){ // 退出登录

        SGNavigationController *nav = [[SGNavigationController alloc] initWithRootViewController:[[SPWelcomeController alloc] init]];
        KEYWINDOW.rootViewController = nav;
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
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}




@end
