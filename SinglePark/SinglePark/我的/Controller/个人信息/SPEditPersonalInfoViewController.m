//
//  SPEditPersonalInfoViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/7.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPEditPersonalInfoViewController.h"
#import "SPMineHeadCell.h"

@interface SPEditPersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *detailArr;
@end

@implementation SPEditPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    
    self.titleArr = @[
                      @[@"头像",@"昵称"],
                      @[@"性别",@"年龄"],
                      @[@"职业",@"所在单位"],
                      @[@"毕业学校",@"学历"],
                      @[@"地区"],
                      @[@"身高",@"体重"],
                      @[@"年收入"],
                      @[@"三观签名"],
                      @[@"引荐人",@"我的邀请码"]
                      ];
    self.detailArr = [NSMutableArray arrayWithArray:@[
                                                      @[@"logo",@"宇宙超无敌美少女"],
                                                      @[@"女",@"18"],
                                                      @[@"工程师",@"平安中心"],
                                                      @[@"深圳大学",@"大学"],
                                                      @[@"广东 深圳"],
                                                      @[@"180CM",@"65KG"],
                                                      @[@"15w"],
                                                      @[@"存在即合理"],
                                                      @[@"logo",@"23KJHF2"]
                                                      ]];
    
    [self setupUI];
    
    [self requestData];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
}

- (void)requestData {
    WEAKSELF
    [JDWNetworkHelper POST:SPURL_API_City parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        STRONGSELF
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        
        [strongSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:Networkerror];
        JDWLog(@"%@",error.localizedDescription);
    }];
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.titleArr[section];
    return arr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SPMineHeadCell *headCell = [[[NSBundle mainBundle] loadNibNamed:@"SPMineHeadCell" owner:nil options:nil] firstObject];
            return headCell;
        }
    }else if (indexPath.section == 8) {
        if (indexPath.row == 0) {
            SPMineHeadCell *headCell = [[[NSBundle mainBundle] loadNibNamed:@"SPMineHeadCell" owner:nil options:nil] firstObject];
            headCell.headTitleLB.text = @"引荐人";
            return headCell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.font = FONT(14);
    cell.textLabel.textColor = SecondWordColor;
    cell.detailTextLabel.textColor = FirstWordColor;
    cell.detailTextLabel.font = FONT(14);
    cell.textLabel.text = self.titleArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.detailArr[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 8) {
        if (indexPath.row == 0) {
            return 70;
        }
    }

    return 45;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}


#pragma mark - Lazy
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = PTBackColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}


@end
