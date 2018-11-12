//
//  SPCommentController.m
//  SinglePark
//
//  Created by DBB on 2018/10/21.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCommentController.h"
#import "SPCommentTablCell.h"

@interface SPCommentController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *messageTabView;
@property (nonatomic,copy)NSString *messageStr;
@property (nonatomic,strong)NSMutableArray *fixedarr;

@end

@implementation SPCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    
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
                          @"messsage":@"哇塞，你好漂亮，我太喜欢你了，美女我们能做朋吗",
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
                           @"messsage":@"恭喜您已通过美女认证",
                           @"coverimg":@"4",
                           @"time":@"12:00"};
    SPMessageModel *model = [[SPMessageModel alloc] initWithDataDic:dic];
    SPMessageModel *model2 = [[SPMessageModel alloc] initWithDataDic:dic2];
    SPMessageModel *model3 = [[SPMessageModel alloc] initWithDataDic:dic3];
    SPMessageModel *model4 = [[SPMessageModel alloc] initWithDataDic:dic4];
    
    self.fixedarr  = [NSMutableArray arrayWithObjects:model4,model3,model,model2, nil];
    [self.messageTabView reloadData];
    
}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fixedarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPCommentTablCell *cell = [tableView dequeueReusableCellWithIdentifier:self.messageStr forIndexPath:indexPath];
    SPMessageModel *moel = self.fixedarr[indexPath.row];
    if ([self.titleStr isEqualToString:@"赞"]) {
        moel.messsage = @"赞了你";
    }
    cell.newsmodel = moel;
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
        self.messageStr = @"commentStr";
        [_messageTabView registerClass:[SPCommentTablCell  class] forCellReuseIdentifier:self.messageStr];
        [self.view addSubview:_messageTabView];
    }
    return _messageTabView;
}


@end
