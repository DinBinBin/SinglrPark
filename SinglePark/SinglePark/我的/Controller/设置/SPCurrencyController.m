//
//  SPCurrencyController.m
//  SinglePark
//
//  Created by DBB on 2018/10/20.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCurrencyController.h"
#import <RongIMKit/RongIMKit.h>


@interface SPCurrencyController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,strong)NSArray *titleArr;
@property(nonatomic,assign)double  cachesize;


@end

@implementation SPCurrencyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通用";

    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getdata];
}

- (void)getdata{
    
    self.titleArr = @[@[@"追求功能"],
                      @[@"清除缓存",@"清除聊天记录"]];
    
    [self.listTabView reloadData];
    
}
#pragma mark ----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.titleArr[section];
    return arr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.textLabel.font = Font16;
    cell.textLabel.textColor = FirstWordColor;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];

    if (indexPath.section == 0) {
        UISwitch *mySwitch = [UISwitch new];
        mySwitch.onTintColor = ThemeColor;
        mySwitch.on = YES;
        cell.accessoryView = mySwitch;

        return cell;
    }else{
        if (indexPath.row == 0) {
            self.cachesize = [self coundCache];
            cell.detailTextLabel.text = [NSString   stringWithFormat:@"%.2fM",self.cachesize];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }else {
            
            cell.textLabel.width = kScreenWidth;
            return cell;
            
        }
    }
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self cleanCache];
            [self.listTabView reloadData];
            [MBProgressHUD showMessage:@"清除成功"];
        }else{
            [[RCIMClient sharedRCIMClient] clearConversations:@[@(ConversationType_PRIVATE),
                                                                @(ConversationType_DISCUSSION),
                                                                @(ConversationType_CHATROOM),
                                                                @(ConversationType_GROUP),
                                                                @(ConversationType_APPSERVICE),
                                                                @(ConversationType_SYSTEM)]];
            [MBProgressHUD showMessage:@"清除成功"];

        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 60;
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenW, 50)];
        label.text = @"如果您关闭了“追求”功能，您将无法得知别人是否喜欢你；";
        label.font = Font14;
        label.textColor = SecondWordColor;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
        headerView.backgroundColor = PTBackColor;
        [headerView addSubview:label];
        
        return headerView;
    }
    
    return nil;
}

// 清楚本地文件
- (void)cleanCache{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *fileName in files)
    {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}


// 计算缓存大小
- (double)coundCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    double fileSize = 0.0;
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *files = [fileManager subpathsAtPath:cachPath];
    for (NSString *fileName in files)
    {
        NSString *path = [cachPath stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:path])
        {
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
            fileSize += (double)([fileAttributes fileSize]);
        }
    }
    
    return fileSize/1024.0/1024.0;
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
