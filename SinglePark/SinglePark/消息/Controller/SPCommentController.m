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
    self.fixedarr = [NSMutableArray arrayWithCapacity:0];
    
    [self setUI];

    [self requestUserCommentList];

}

- (void)setUI{
    [self.messageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)requestUserCommentList {
    
    NSDictionary *parameters = @{@"page":@"1",@"limit":@"10"};

    NSString *url = @"";
    if ([self.titleStr isEqualToString:@"评论"]) {
        url = SPMineCommentList;
    }else{
        url = SPMineCommentList;
    }
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:SPMineCommentList parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *items = responseDic[@"data"][@"items"];
            if (items.count > 0) {
                [self.fixedarr removeAllObjects];
                for (int a=0; a<items.count; a++) {
                    NSDictionary *item = items[a];
                    SPPersonModel *fromeUser = [SPPersonModel modelWithJSON:item[@"user"]];
                    
                    SPMessageModel *model = [[SPMessageModel alloc] init];
                    model.head = fromeUser.avatar;
                    model.messsage = item[@"content"];
                    model.time = fromeUser.updated_at;
                    model.nickName = fromeUser.nickName;
                    model.coverimg = item[@"video"][@"video"];
                    model.user = fromeUser;
                    model.user.first_video = [SPCoverModel new];
                    model.user.first_video.thumb = item[@"video"][@"thumb"];
                    model.user.first_video.thumb_id = item[@"video"][@"thumb_id"];
                    model.user.first_video.videoId = item[@"video"][@"id"];

                    
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
    SPCommentTablCell *cell = [tableView dequeueReusableCellWithIdentifier:self.messageStr forIndexPath:indexPath];
    SPMessageModel *model = self.fixedarr[indexPath.row];
    if ([self.titleStr isEqualToString:@"赞"]) {
        model.messsage = @"赞了你";
    }
    cell.newsmodel = model;
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
