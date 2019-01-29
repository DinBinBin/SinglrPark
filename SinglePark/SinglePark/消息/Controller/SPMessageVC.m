//
//  SPMessageVC.m
//  SinglePark
//
//  Created by DBB on 2018/8/12.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPMessageVC.h"
#import "SPMessageTabCell.h"
#import "SPSystemController.h"
#import "SPCommentController.h"
#import "SPChasingController.h"
#import "SPChatListViewController.h"
#import "LCLoginController.h"
#import <RongIMKit/RongIMKit.h>
#import "UITabBar+SPTabBar.h"


@interface SPMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *messageTabView;
@property (nonatomic,copy)NSString *messageStr;
@property (nonatomic,strong)NSMutableArray *fixedarr;
@property (nonatomic, assign) int unreadSum;
@property (nonatomic, assign) int RCcount;//融云消息未读数

@end

@implementation SPMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //获取融云未读消息
    self.RCcount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
                                                                   @(ConversationType_DISCUSSION),
                                                                   @(ConversationType_CHATROOM),
                                                                   @(ConversationType_GROUP),
                                                                   @(ConversationType_APPSERVICE),
                                                                   @(ConversationType_SYSTEM)]];
    
    [self getModel];
    

}


- (void)setUI{
    [self.messageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)getModel{
    
    if (![DBAccountInfo sharedInstance].islogin) {
        LCLoginController *tourist = [[LCLoginController alloc] init];
        tourist.iswelecome = NO;
        [self.navigationController pushViewController:tourist animated:YES];
        return;
    }
    
    
    
    NSDictionary *dic = @{@"head":@"chase",
                          @"nickName":@"追讯",
                          @"messsage":@"恭喜您已通过美女认证",
                              @"time":@"12:00",
                          @"unreadCount":@"0"
                          };
    NSDictionary *dic2 = @{@"head":@"good",
                          @"nickName":@"点赞",
                           @"messsage":@"恭喜您已通过美女认证",
                           @"time":@"14:00",
                           @"unreadCount":@"0"};
    NSDictionary *dic3 = @{@"head":@"message",
                          @"nickName":@"评论",
                          @"messsage":@"恭喜您已通过美女认证",
                           @"time":@"12:00",
                           @"unreadCount":@"0"};
    NSDictionary *dic4 = @{@"head":@"notice",
                          @"nickName":@"单身公园",
                          @"messsage":@"恭喜您已通过美女认证",
                           @"time":@"12:00",
                           @"unreadCount":@"0"};
    NSDictionary *dic5 = @{@"head":@"notice",
                           @"nickName":@"聊天窗口",
                           @"messsage":@"好友聊天都在这里哦",
                           @"time":@"12:00",
                           @"unreadCount":[NSString stringWithFormat:@"%d",self.RCcount]};
    SPMessageModel *model = [SPMessageModel modelWithJSON:dic];
    SPMessageModel *model2 = [SPMessageModel modelWithJSON:dic2];
    SPMessageModel *model3 = [SPMessageModel modelWithJSON:dic3];
    SPMessageModel *model4 = [SPMessageModel modelWithJSON:dic4];
    SPMessageModel *model5 = [SPMessageModel modelWithJSON:dic5];


    self.fixedarr  = [NSMutableArray arrayWithObjects:model4,model3,model,model2,model5, nil];
    
    int count=0;
    for (SPMessageModel *modelCount in self.fixedarr) {
        count = count + modelCount.unreadCount;
    }
    

    self.unreadSum = count + self.RCcount;
    [self.tabBarController.tabBar showBadgeOnItemIndex:1 count:self.unreadSum];

    [self.messageTabView reloadData];
    
}

#pragma mark ----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fixedarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPMessageTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.messageStr forIndexPath:indexPath];
    cell.model = self.fixedarr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SPSystemController *systme = [[SPSystemController alloc ] init];
        [self.navigationController   pushViewController:systme animated:YES];
    }else if (indexPath.row == 1){
        SPCommentController *systme = [[SPCommentController alloc ] init];
        systme.titleStr = @"评论";
        [self.navigationController   pushViewController:systme animated:YES];


    }else if (indexPath.row == 2){
        SPChasingController *systme = [[SPChasingController alloc ] init];
        [self.navigationController   pushViewController:systme animated:YES];

    }else if (indexPath.row == 3){
        SPCommentController *systme = [[SPCommentController alloc ] init];
        systme.titleStr = @"赞";
        [self.navigationController   pushViewController:systme animated:YES];

    }else if (indexPath.row == 4){
        SPChatListViewController *chat = [[SPChatListViewController alloc] init];
        [self.navigationController pushViewController:chat animated:YES];
    }
    
    
    SPMessageModel *model = self.fixedarr[indexPath.row];
    if (model.unreadCount <= self.unreadSum) {
        self.unreadSum = self.unreadSum - model.unreadCount;
        [self.tabBarController.tabBar showBadgeOnItemIndex:1 count:self.unreadSum];
    }

}


- (UITableView *)messageTabView{
    if (_messageTabView == nil) {
        _messageTabView = [[UITableView alloc] init];
        _messageTabView.dataSource = self;
        _messageTabView.delegate = self;
        _messageTabView.backgroundColor = PTBackColor;
        _messageTabView.tableFooterView = [[UIView alloc] init];
        self.messageStr = @"messageStr";
        [_messageTabView registerClass:[SPMessageTabCell class] forCellReuseIdentifier:self.messageStr];
        [self.view addSubview:_messageTabView];
    }
    return _messageTabView;
}



@end
