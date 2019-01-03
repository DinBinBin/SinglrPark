//
//  SPCoverListView.m
//  SinglePark
//
//  Created by DBB on 2018/10/4.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCoverListView.h"
#import "SPCoverTabCell.h"
#import "SPPlayVideoController.h"
#import "SPPlayVideoController.h"
#import "LCLoginController.h"

@interface SPCoverListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger num;

@end

@implementation SPCoverListView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setListUI];
        [self getdata];
    }
    return self;
}

- (void)setListUI{
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.listTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getdata)];
    self.listTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoredata)];

}


// 加载数据
- (void)getdata{
    NSString *choose;
    switch (self.choosetype) {
        case 1:
            choose = @"1";
            break;
        case 2:
            choose = @"2";

            break;
        case 3:
            choose = @"3";

            break;
        default:
            break;
    }
    
//    NSDictionary *parms = @{@"":@""};
    NSDictionary *dic = @{@"head":@"logo",
                          @"distance":@"距离----",
                          @"nickName":@"昵称----",
                          @"sex":@"nv",
                          @"videoCover":@"5"};
//    SPCoverModel *model = [SPCoverModel modelWithJSON:dic];
//    [self.dataArr addObject:model];
//    [self.dataArr addObject:model];
//    [self.dataArr addObject:model];
//    [self.dataArr addObject:model];
    
    self.dataArr = [NSMutableArray array];
//    获取视频列表
    self.num = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.num],@"page",@"10",@"limit", nil];
    if (self.islocal) {  //是本地
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.longitude] forKey:@"longitude"];
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.latitude] forKey:@"latitude"];

    }
    
    
    
    [JDWNetworkHelper POST:PTURL_API_Index parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
           self.dataArr = [[SPPersonModel modelArrayWithJSON:responseDic[@"data"][@"items"]] mutableCopy];
            
            [self.listTabView reloadData];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
        [self.listTabView.mj_header endRefreshing ];
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [self.listTabView.mj_header endRefreshing ];

    }];
    
    
    
    
}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPCoverTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.coverStr forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![DBAccountInfo sharedInstance].isTouris && [DBAccountInfo sharedInstance].islogin) {
        SPPlayVideoController *play = [[SPPlayVideoController alloc] init];
        play.selectIndex = indexPath.row;
        play.datasource = self.dataArr;
        play.choosetype = self.choosetype;
        play.islocal = self.islocal;
        [[self viewController].navigationController pushViewController:play animated:YES];

    }else{
        //        [UIAlertController showNormalAlert:KEYWINDOW.rootViewController messafe:@"使用平台账号登录才能进入" lefStr:@"取消" rightStr:@"登录" left:^{
        //        } right:^{
        LCLoginController *login = [[LCLoginController alloc ] init];
        [[self viewController].navigationController pushViewController:login animated:YES];
        //        } leftColor:FirstWordColor rightColor: ThemeColor];
    }
}


- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        self.coverStr = @"coverId";
        _listTabView.backgroundColor = PTBackColor;
        [_listTabView registerClass:[SPCoverTabCell class] forCellReuseIdentifier:self.coverStr];
        _listTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTabView.tableFooterView = [[UIView alloc] init];
        [self addSubview:_listTabView];
    }
    return _listTabView;
}

- (void)setChoosetype:(ChooseType)choosetype{
    if (_choosetype != choosetype) {
        _choosetype = choosetype;
        [self getdata];
    }
    
}



// 加载数据
- (void)getMoredata{
    NSString *choose;
    switch (self.choosetype) {
        case 1:
            choose = @"1";
            break;
        case 2:
            choose = @"2";
            
            break;
        case 3:
            choose = @"3";
            
            break;
        default:
            break;
    }
    
    //    获取视频列表
    self.num++;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.num],@"page",@"10",@"limit", nil];
    if (self.islocal) {  //是本地
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.longitude] forKey:@"longitude"];
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.latitude] forKey:@"latitude"];
        
    }
    
    
    
    [JDWNetworkHelper POST:PTURL_API_Index parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        [self.listTabView.mj_footer endRefreshing ];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            
           NSArray *arr = [[SPPersonModel modelArrayWithJSON:responseDic[@"data"][@"items"]] mutableCopy];
            [self.dataArr addObjectsFromArray:arr];
            [self.listTabView reloadData];
            if (self.num == [responseDic[@"data"][@"total"] integerValue]) {
                [self.listTabView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [self.listTabView.mj_footer endRefreshing ];

    }];
    
    
    
    
}

@end
