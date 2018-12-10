//
//  SPJobViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/6.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPJobViewController.h"
#import "SPJobModel.h"

@interface SPJobViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SPJobModel *> *dataSource;
@end

@implementation SPJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择职业";
    
    [self setupUI];
    
    [self requestData];
    
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
}

- (void)requestData {
    WEAKSELF
    [JDWNetworkHelper POST:SPURL_API_Job parameters:nil success:^(id responseObject) {
        STRONGSELF
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        strongSelf.dataSource =  [SPJobModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
        
        [strongSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        JDWLog(@"%@",error.localizedDescription);
    }];
    

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row].name;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectJobName:)]) {
        [self.delegate selectJobName:self.dataSource[indexPath.row].name];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Lazy
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = PTBackColor;
        _tableView.tableFooterView = [[UIView alloc] init];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

@end
