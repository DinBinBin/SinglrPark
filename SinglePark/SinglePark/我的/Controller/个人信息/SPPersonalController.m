//
//  SPPersonalController.m
//  SinglePark
//
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPersonalController.h"
#import "SPHeadPersonTabCell.h"

@interface SPPersonalController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,strong)SPPersonModel *personmodel;
@end

@implementation SPPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self getdata];
}

- (void)getdata{
    self.titleArr = @[@[@""],@[@"性别",@"年龄",@"职业",@"所在单位",@"毕业学校",@"学历",@"引荐人"],@[@"地区",@"身高",@"体重",@"年收入"],@[@"加入黑名单",@"投诉"]];
    

     
    NSDictionary *dic1 = @{@"head":@"4",
                           @"occupation":@"15115912877",
                           @"nickName":@"昵称----",
                           @"sex":@"1",
                           @"singer":@"伴着我的歌声是你心碎的幻想，你用你的眼泪抚摸我的寂寞",
                           @"didian":@"广东深圳",
                           @"number":@[@"4",@"4",@"4"]
                           };
    self.personmodel = [SPPersonModel modelWithJSON:dic1];
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

    if (indexPath.section == 0) {
        SPHeadPersonTabCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.coverStr forIndexPath:indexPath];
        cell.model =  self.personmodel;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.font = FONT(14);
        cell.textLabel.textColor = SecondWordColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.row < arr.count-1) {
            return cell;

        }
        cell.detailTextLabel.textColor = FirstWordColor;
        cell.detailTextLabel.font = FONT(14);
        return cell;
    }else if(indexPath.section == 2)   {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.font = FONT(14);
        cell.textLabel.textColor = SecondWordColor;
        cell.detailTextLabel.textColor = FirstWordColor;
        cell.detailTextLabel.font = FONT(14);
    cell.detailTextLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.text = arr[indexPath.row];
        cell.textLabel.font = FONT(14);
        cell.textLabel.textColor = SecondWordColor;

        if (indexPath.row == 0) {
            UISwitch *switchblack = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            
        }
        return cell;

    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>=2) {
        
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
        _listTabView.tableFooterView = [UIView new];
        self.coverStr = @"coverStrhead";
        [_listTabView registerClass:[SPHeadPersonTabCell class] forCellReuseIdentifier:self.coverStr];
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}


@end
