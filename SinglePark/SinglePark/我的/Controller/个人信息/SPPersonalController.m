//
//  SPPersonalController.m
//  SinglePark
//
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPersonalController.h"
#import "SPHeadPersonTabCell.h"
#import "SPCityModel.h"
#import "SPComplaintPeopleController.h"

@interface SPPersonalController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *detailArr;
@property (nonatomic,strong)SPPersonModel *personmodel;

@property (nonatomic,strong)UISwitch *switchblack;
@end

@implementation SPPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (!self.model.areaName) {
        [self requestProvinceName];
    }
    [self getdata];
}

- (void)getdata{
    self.titleArr = @[@[@""],@[@"性别",@"生日",@"职业",@"所在单位",@"毕业学校",@"学历",@"引荐人"],@[@"地区",@"身高",@"体重",@"年收入"],@[@"加入黑名单",@"投诉"]];
    self.detailArr = [NSMutableArray arrayWithCapacity:0];

     
//    NSDictionary *dic1 = @{@"avatar":@"4",
//                           @"occupation":@"15115912877",
//                           @"nick_name":@"昵称----",
//                           @"sex":@"1",
//                           @"singer":@"伴着我的歌声是你心碎的幻想，你用你的眼泪抚摸我的寂寞",
//                           @"didian":@"广东深圳",
//                           @"number":@[@"4",@"4",@"4"]
//                           };
//    self.personmodel = [SPPersonModel modelWithJSON:dic1];
    [self reloadDataSource];
    
}


- (void)requestProvinceName {
    WEAKSELF
    STRONGSELF
    NSString *strId = [NSString stringWithFormat:@"%ld",(long)[DBAccountInfo sharedInstance].model.province_id];
    NSString *url = [SPURL_API_CityName stringByAppendingPathComponent:strId];
    [MBProgressHUD showLoadToView:self.view];
    
    [JDWNetworkHelper POST:url parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            
            [strongSelf.detailArr removeAllObjects];
            SPCityModel *model = [SPCityModel modelWithJSON:responseDic[@"data"]];
            NSString *name = [NSString stringWithFormat:@"%@ %@",strongSelf.model.areaName ?:@"",model.name];
            strongSelf.model.areaName = name;
            
            [strongSelf requestCityName];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
}

- (void)requestCityName {
    NSString *strId = [NSString stringWithFormat:@"%ld",(long)[DBAccountInfo sharedInstance].model.city_id];
    NSString *url = [SPURL_API_CityName stringByAppendingPathComponent:strId];
    
    WEAKSELF
    STRONGSELF
    [JDWNetworkHelper POST:url parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            
            [strongSelf.detailArr removeAllObjects];
            SPCityModel *model = [SPCityModel modelWithJSON:responseDic[@"data"]];
            NSString *name = [NSString stringWithFormat:@"%@ %@",strongSelf.model.areaName ?:@"",model.name];
            strongSelf.model.areaName = name;
            
            [strongSelf requestDistrictName];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
    
}
- (void)requestDistrictName {
    NSString *strId = [NSString stringWithFormat:@"%ld",(long)[DBAccountInfo sharedInstance].model.district_id];
    NSString *url = [SPURL_API_CityName stringByAppendingPathComponent:strId];
    WEAKSELF
    STRONGSELF
    
    [JDWNetworkHelper POST:url parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [strongSelf.detailArr removeAllObjects];
            SPCityModel *model = [SPCityModel modelWithJSON:responseDic[@"data"]];
            NSString *name = [NSString stringWithFormat:@"%@ %@",strongSelf.model.areaName ?: @"",model.name];
            strongSelf.model.areaName = name;
            [strongSelf reloadDataSource];
            
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        [MBProgressHUD hideHUDForView:strongSelf.view];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
        [MBProgressHUD hideHUDForView:strongSelf.view];
        
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

    if (indexPath.section == 0) {
        SPHeadPersonTabCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.coverStr forIndexPath:indexPath];
        cell.model =  self.model;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.font = Font16;
        cell.textLabel.textColor = SecondWordColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = self.detailArr[0][indexPath.row];
        cell.detailTextLabel.textColor = FirstWordColor;
        if (indexPath.row < arr.count-1) {
            return cell;

        }
        cell.detailTextLabel.textColor = FirstWordColor;
        cell.detailTextLabel.font = Font16;
        return cell;
    }else if(indexPath.section == 2)   {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.font = Font16;
        cell.textLabel.textColor = SecondWordColor;
        cell.detailTextLabel.textColor = FirstWordColor;
        cell.detailTextLabel.font = Font16;
        cell.detailTextLabel.text = self.detailArr[1][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.font = Font16;
        cell.textLabel.textColor = SecondWordColor;

        if (indexPath.row == 0) {
            self.switchblack = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            [cell.contentView addSubview:self.switchblack];
            [self.switchblack addTarget:self action:@selector(pullblack:) forControlEvents:UIControlEventValueChanged];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;

    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>=2) {
        
    }
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (void)reloadDataSource {
    
    
    NSString *sex;
    if (_model.sex == 0) {
        sex = @"未填写";
    }else if (_model.sex == 1){
        sex = @"男";
    }else{
        sex = @"女";
    }
    
    self.detailArr = [NSMutableArray arrayWithArray:@[
                                                      @[sex,self.model.birthday ?: @"未填写",self.model.job.firstObject?:@"未填写",self.model.company ?: @"未填写",self.model.college ?:@"未填写",[self jsonEdcation:self.model.education],self.model.referrer ?:@"logo"],
                                                      @[self.model.areaName ?:@"未填写",[self jsonHeight:self.model.hights],[self jsonWeight:self.model.weights],[self jsonIncomes:self.model.incomes]],
                                                      ]
                      ];
    [self.listTabView reloadData];
}


- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        _listTabView.tableFooterView = [UIView new];
        self.coverStr = @"coverStrhead";
        [_listTabView registerClass:[SPHeadPersonTabCell class] forCellReuseIdentifier:self.coverStr];
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}



#pragma mark - private
- (NSString *)jsonSex:(int)sex {
    NSString *last = @"";
    if (sex == 0) {
        last = @"保密";
    }else if (sex == 1){
        last = @"男";
    }else{
        last = @"女";
    }
    return last;
}

- (NSString *)jsonEdcation:(NSString *)edcation {
    NSString *last = @"";
    if ([edcation isEqualToString:@"1"]) {
        last = @"保密";
    }else if ([edcation isEqualToString:@"2"]){
        last = @"小学";
    }else if ([edcation isEqualToString:@"3"]){
        last = @"初中";
    }else if ([edcation isEqualToString:@"4"]){
        last = @"高中";
    }else if ([edcation isEqualToString:@"5"]){
        last = @"专科";
    }else if ([edcation isEqualToString:@"6"]){
        last = @"本科";
    }else if ([edcation isEqualToString:@"7"]){
        last = @"硕士";
    }else if ([edcation isEqualToString:@"8"]){
        last = @"博士";
    }
    return last;
}


- (NSString *)jsonHeight:(NSString *)height {
    NSString *last = @"";
    if ([height isEqualToString:@""] || height == nil) {
        last = @"未填写";
        
    }else{
        last = [NSString stringWithFormat:@"%@CM",height];
        
    }
    return last;
}

- (NSString *)jsonWeight:(NSString *)weight {
    NSString *last = @"";
    if ([weight isEqualToString:@""] || weight == nil) {
        last = @"未填写";
    }else{
        last = [NSString stringWithFormat:@"%@KG",weight];
        
    }
    return last;
}

- (NSString *)jsonIncomes:(NSString *)incoms {
    NSString *last = @"";
    if ([incoms isEqualToString:@"1"]) {
        last = @"保密";
    }else if ([incoms isEqualToString:@"2"]) {
        last = @"10万以上";
    }else if ([incoms isEqualToString:@"3"]) {
        last = @"20万以上";
    }else if ([incoms isEqualToString:@"4"]) {
        last = @"50万以上";
    }else if ([incoms isEqualToString:@"5"]) {
        last = @"100万以上";
    }else{
        last = @"未填写";
    }
    return last;
}


- (NSString *)jsonCompany:(NSString *)company {
    NSString *last = @"";
    if ([company isEqualToString:@""] || company == nil) {
        last = @"未填写";
    }else{
        last = company;
    }
    return last;
}

- (NSString *)jsonCollege:(NSString *)college {
    NSString *last = @"";
    if ([college isEqualToString:@""] || college == nil) {
        last = @"未填写";
    }else{
        last = college;
    }
    return last;
}


- (UISwitch *)switchblack{
    
    return _switchblack;
}

- (void)pullblack:(UISwitch *)witch{
    witch.selected = witch.selected;
    if(witch.selected){  //拉黑
        [self selectCover];
    }else{  // 取消
        
        
    }
}


- (void)selectCover{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"加入黑名单，你将不再收到对方的消息" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

    }];
    
    [photo setValue:TextMianColor forKey:@"_titleTextColor"];
    
    UIAlertAction * choice = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        去拉黑

    }];
    [choice setValue:TextMianColor forKey:@"_titleTextColor"];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        SPComplaintPeopleController *complaint = [[SPComplaintPeopleController alloc] init];
        complaint.model = self.model;
        [self.navigationController pushViewController:complaint animated:YES];
    }];
    
    [alertController addAction:choice];
    [alertController addAction:cancel];
    [self showDetailViewController:alertController sender:nil];
}

//- (void)
@end
