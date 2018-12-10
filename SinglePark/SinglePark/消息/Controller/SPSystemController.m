//
//  SPSystemController.m
//  SinglePark
//
//  Created by DBB on 2018/10/5.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPSystemController.h"
#import "JDWPlatformNewsTabCell.h"

@interface SPSystemController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *messageTabView;
@property (nonatomic,copy)NSString *messageStr;
@property (nonatomic,strong)NSMutableArray *fixedarr;

@end

@implementation SPSystemController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统消息";
    
    [self setUI];
    [self getModel];
}

- (void)setUI{
    [self.messageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)getModel{
    
    NSDictionary *dic = @{@"head":@"chase",
                          @"nickName":@"追讯",
                          @"messsage":@"恭喜您已通过美女认证",
                          @"time":@"12:00"};
    NSDictionary *dic2 = @{@"head":@"good",
                           @"nickName":@"点赞",
                           @"messsage":@"恭喜您已通过美女认证",
                           @"time":@"14:00"};
    NSDictionary *dic3 = @{@"head":@"message",
                           @"nickName":@"评论",
                           @"messsage":@"恭喜您已通过美女认证",
                           @"time":@"12:00"};
    NSDictionary *dic4 = @{@"head":@"notice",
                           @"nickName":@"单身公园",
                           @"messsage":@"恭喜您已通过美女认证",
                           @"time":@"12:00"};

    SPMessageModel *model = [SPMessageModel modelWithJSON:dic];
    SPMessageModel *model2 = [SPMessageModel modelWithJSON:dic2];
    SPMessageModel *model3 = [SPMessageModel modelWithJSON:dic3];
    SPMessageModel *model4 = [SPMessageModel modelWithJSON:dic4];

    
    self.fixedarr  = [NSMutableArray arrayWithObjects:model4,model3,model,model2, nil];
    [self.messageTabView reloadData];
    
}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fixedarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JDWPlatformNewsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.messageStr forIndexPath:indexPath];
    cell.newsmodel = self.fixedarr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = PTBackColor;
    return cell;
}



- (UITableView *)messageTabView{
    if (_messageTabView == nil) {
        _messageTabView = [[UITableView alloc] init];
        _messageTabView.dataSource = self;
        _messageTabView.delegate = self;
        _messageTabView.backgroundColor = PTBackColor;
        _messageTabView.tableFooterView = [[UIView alloc] init];
        _messageTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.messageStr = @"messageStr";
        [_messageTabView registerClass:[JDWPlatformNewsTabCell  class] forCellReuseIdentifier:self.messageStr];
        [self.view addSubview:_messageTabView];
    }
    return _messageTabView;
}


@end
