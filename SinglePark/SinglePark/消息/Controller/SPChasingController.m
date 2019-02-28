//
//  SPChasingController.m
//  SinglePark
//
//  Created by DBB on 2018/10/25.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPChasingController.h"
#import "SPChasingTabCell.h"
#import "SPChasingTwoTabCell.h"
#import "SPThirdTabwCell.h"

@interface SPChasingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *messageTabView;
@property (nonatomic,copy)NSString *chasingOne;
@property (nonatomic,copy)NSString *chasingTwo;
@property (nonatomic,copy)NSString *chasingThred;
@property (nonatomic,strong)NSMutableArray *fixedarr;

@end

@implementation SPChasingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认音讯";
    self.fixedarr = [NSMutableArray arrayWithCapacity:0];
    
    [self setUI];
//    [self getModel];
    
    [self requestData];
}

- (void)setUI{
    [self.messageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)getModel{
    
    NSDictionary *dic = @{@"head":@"chase",
                          @"nickName":@"确认音讯",
                          @"messsage":@"拒绝了你",
                          @"coverimg":@"4",
                          @"time":@"12:00"};
    NSDictionary *dic2 = @{@"head":@"good",
                           @"nickName":@"点赞",
                           @"messsage":@"恭喜您已通过美女认证",
                           @"coverimg":@"4",
                           @"time":@"14:00"};
    NSDictionary *dic3 = @{@"head":@"message",
                           @"nickName":@"评论",
                           @"messsage":@"恭喜您已通过美女认证",
                           @"coverimg":@"4",
                           @"time":@"12:00"};
    NSDictionary *dic4 = @{@"head":@"notice",
                           @"nickName":@"单身公园",
                           @"messsage":@"接受了你",
                           @"coverimg":@"4",
                           @"time":@"12:00"};
    SPMessageModel *model = [SPMessageModel modelWithJSON:dic];
    SPMessageModel *model2 = [SPMessageModel modelWithJSON:dic2];
    SPMessageModel *model3 = [SPMessageModel modelWithJSON:dic3];
    SPMessageModel *model4 = [SPMessageModel modelWithJSON:dic4];

    self.fixedarr  = [NSMutableArray arrayWithObjects:model4,model3,model,model2, nil];
    [self.messageTabView reloadData];
    
}

- (void)requestData {
    NSDictionary *parameters = @{@"page":@"1",@"limit":@"10"};
    
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:SPURL_API_Follows parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *items = responseDic[@"data"][@"items"];
            if (items.count > 0) {
                [self.fixedarr removeAllObjects];
                for (int a=0; a<items.count; a++) {
                    NSDictionary *item = items[a];
                    SPPersonModel *fromeUser = [SPPersonModel modelWithJSON:item[@"from_user"]];
                    
                    SPMessageModel *model = [[SPMessageModel alloc] init];
                    model.head = fromeUser.avatar;
                    model.messsage = @"接受了你";
                    model.time = fromeUser.updated_at;
                    model.nickName = fromeUser.nickName;
                    
                    [self.fixedarr addObject:model];
                }
                

            }
            
            [self.messageTabView reloadData];
            
        }else{
            if ([responseDic[@"messages"] isKindOfClass: [NSNull class]]) {
                [MBProgressHUD showAutoMessage:@"请求失败"];
                
            }else{
                [MBProgressHUD showAutoMessage:responseDic[@"messages"]];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fixedarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPMessageModel *model = self.fixedarr[indexPath.row];
    if ([model.head floatValue] == 1) {
        SPChasingTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.chasingOne forIndexPath:indexPath];
        cell.newsmodel = model;
        return cell;
    }else if ([model.head floatValue] == 2){
        SPChasingTwoTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.chasingTwo forIndexPath:indexPath];
        cell.newsmodel = model;
        return cell;

    }else{
        SPThirdTabwCell *cell = [tableView dequeueReusableCellWithIdentifier:self.chasingThred forIndexPath:indexPath];
        cell.newsmodel = model;
        return cell;

    }
}



- (UITableView *)messageTabView{
    if (_messageTabView == nil) {
        _messageTabView = [[UITableView alloc] init];
        _messageTabView.dataSource = self;
        _messageTabView.delegate = self;
        _messageTabView.backgroundColor = PTBackColor;
        _messageTabView.tableFooterView = [[UIView alloc] init];
        _messageTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.chasingOne = @"chasingOne";
        self.chasingTwo = @"chasingTwo";
        self.chasingThred = @"chasingThred";
        [_messageTabView registerClass:[SPChasingTabCell  class] forCellReuseIdentifier:self.chasingOne];
        [_messageTabView registerClass:[SPChasingTwoTabCell  class] forCellReuseIdentifier:self.chasingTwo];
        [_messageTabView registerClass:[SPThirdTabwCell  class] forCellReuseIdentifier:self.chasingThred];
        [self.view addSubview:_messageTabView];
    }
    return _messageTabView;
}




@end
