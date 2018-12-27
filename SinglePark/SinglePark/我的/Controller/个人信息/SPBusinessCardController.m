//
//  SPBusinessCardController.m
//  SinglePark
//
//  Created by DBB on 2018/10/5.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPBusinessCardController.h"
#import "SPCardTabCell.h"
#import "SPCardVideoTabCell.h"
#import "SPChasingherController.h"

@interface SPBusinessCardController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,copy)NSString *coverStr2;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)SPPersonModel *personmodel;
@property (nonatomic,strong)UIButton *hunterBtn;
@end

@implementation SPBusinessCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.nickName;
    
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self getdata];
}

- (void)getdata{
    //    NSDictionary *parms = @{@"":@""};
    NSDictionary *dic = @{@"avatar":@"4",
                          @"distance":@"距离----",
                          @"nickName":@"昵称----",
                          @"sex":@"1",
                          @"videoCover":@"5"};
    SPCoverModel *model = [SPCoverModel modelWithJSON:dic];
    self.dataArr = [NSMutableArray array];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];
    [self.dataArr addObject:model];
    
    
    NSDictionary *dic1 = @{@"avatar":@"4",
                          @"occupation":@"距离----",
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
    return 2+self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SPCardTabCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.coverStr forIndexPath:indexPath];
        cell.model =  self.personmodel;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.contentView addSubview:self.hunterBtn];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        SPCardVideoTabCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.coverStr2 forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

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
        self.coverStr = @"coverId";
        [_listTabView registerClass:[SPCardTabCell class] forCellReuseIdentifier:self.coverStr];
        self.coverStr2 = @"coverId2";
        [_listTabView registerClass:[SPCardVideoTabCell class] forCellReuseIdentifier:self.coverStr2];

        _listTabView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5"]];
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}

- (UIButton *)hunterBtn{
    if (_hunterBtn == nil) {
        _hunterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hunterBtn.frame = CGRectMake(10, 0, kScreenWidth-20, 44);
        [_hunterBtn setCornerRadius:5];
        _hunterBtn.backgroundColor = ThemeColor;
        [_hunterBtn setTitle:@"追她" forState:UIControlStateNormal];
        [_hunterBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            SPChasingherController *chasing = [[SPChasingherController alloc] init];
            [self.navigationController pushViewController:chasing animated:YES];
        }];
    }
    return  _hunterBtn;
}

@end
