//
//  SPAreaViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/7.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPAreaViewController.h"
#import "SPCityModel.h"

@interface SPAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SPCityModel *> *dataArr;
@property (nonatomic, assign) BOOL nextCity;
@property (nonatomic, assign) BOOL nextDistrict;
@property (nonatomic, copy) NSString *name;
@end

@implementation SPAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择地区";
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    self.nextCity = NO;
    self.nextDistrict = NO;
    
    [self setupUI];
    
    [self requestData];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
}

/*
 {
 "name" : "忠县",
 "value" : "3367",
 "parent" : "394"
 },
 */
- (void)requestData {
    WEAKSELF
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:SPURL_API_City parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.dataArr removeAllObjects];
        STRONGSELF
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
            
            NSArray *dataArr =  [SPCityModel mj_objectArrayWithKeyValuesArray:responseDic[@"data"]];
            for (SPCityModel *model in dataArr) {
                if (model.parent == 0) {
                    [strongSelf.dataArr addObject:model];
                }
            }
            
            [strongSelf.tableView reloadData];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];

        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:Networkerror];
        JDWLog(@"%@",error.localizedDescription);
    }];
    
    
}

- (void)requestNextData:(NSInteger)areaID {
    NSString *strId = [NSString stringWithFormat:@"%ld",(long)areaID];
    NSString *url = [SPURL_API_City stringByAppendingPathComponent:strId];
    WEAKSELF

    [JDWNetworkHelper POST:url parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.dataArr removeAllObjects];
        STRONGSELF
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
            NSArray *dataArr =  [SPCityModel modelArrayWithJSON:responseDic[@"data"]];
            
            if (dataArr.count == 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(selectAreaName:)]) {
                    
                    [DBAccountInfo sharedInstance].model.district_id = 0;
                    [DBAccountInfo sharedInstance].model.areaName = self.name;
                    [self.delegate selectAreaName:self.name];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }

            for (SPCityModel *model in dataArr) {
                
                if (model.parent > 0) {
                    [strongSelf.dataArr addObject:model];
                }
            }
            
            [strongSelf.tableView reloadData];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
    
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        JDWLog(@"%@",error.localizedDescription);
    }];
    
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row].name;
    cell.textLabel.font = Font14;
    cell.textLabel.textColor = SecondWordColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.nextCity) {
        self.nextCity = YES;
        self.name = self.dataArr[indexPath.row].name;
        [DBAccountInfo sharedInstance].model.province_id = self.dataArr[indexPath.row].value;

        [self requestNextData:self.dataArr[indexPath.row].value];
    }else {
        if (!self.nextDistrict) {
            self.nextDistrict = YES;
            self.name = [NSString stringWithFormat:@"%@ %@",self.name,self.dataArr[indexPath.row].name];
            //保存用户信息
            [DBAccountInfo sharedInstance].model.city_id = self.dataArr[indexPath.row].value;

            [self requestNextData:self.dataArr[indexPath.row].value];

        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectAreaName:)]) {
                self.name = [NSString stringWithFormat:@"%@ %@",self.name,self.dataArr[indexPath.row].name];
                //保存用户信息
                [DBAccountInfo sharedInstance].model.district_id = self.dataArr[indexPath.row].value;
                [DBAccountInfo sharedInstance].model.areaName = self.name;
                [self.delegate selectAreaName:self.name];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
    
    
}


#pragma mark - Lazy
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = PTBackColor;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

@end
