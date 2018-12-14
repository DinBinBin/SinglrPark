//
//  SPProtectionOptViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/14.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPProtectionOptViewController.h"

@interface SPProtectionOptViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,strong)NSArray *titleArr;

@end

@implementation SPProtectionOptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料隐私保护";
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getdata];
}

- (void)getdata{
    self.titleArr = @[@"我追的人可见",@"追我的人可见"];
    
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
    NSInteger row = [DBAccountInfo sharedInstance].model.config_privacy - 1;
    if (indexPath.row == row) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:ImageNamed(@"chase")];
        imageView.frame = CGRectMake(0, 0, 20, 20);
        cell.accessoryView = imageView;
        
    }
    
    if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        
    }else{
        [DBAccountInfo sharedInstance].model.config_privacy = indexPath.row + 1;
        [tableView reloadData];
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
