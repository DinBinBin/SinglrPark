//
//  SPChatListViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/4.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPChatListViewController.h"
#import "SPConversationViewController.h"


@interface SPChatListViewController ()<RCIMUserInfoDataSource>
@property (nonatomic, strong)NSArray *friends;
@end

@implementation SPChatListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_CHATROOM),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION)]];
        
        self.friends = [[SPFriendDBManger shareInstance] searchAllFeiend];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 替换back按钮
    UIBarButtonItem *backBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"back"
                                                                     imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)
                                                                              target:self
                                                                              action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    self.title = @"聊天窗口";
    
    self.conversationListTableView.tableFooterView = [UIView new];
    self.conversationListTableView.backgroundColor = PTBackColor;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
    lab.center = self.conversationListTableView.center;
    lab.text = @"暂时没有会话";
    lab.font = Font16;
    lab.textColor = SecondWordColor;
    self.emptyConversationView = lab;
    self.emptyConversationView.hidden = YES;
    
    [RCIM sharedRCIM].userInfoDataSource = self;

    
}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    SPConversationViewController *conversationVC = [[SPConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    
    for (SPPersonModel *friend in self.friends) {
        if ([model.targetId isEqualToString:[NSString stringWithFormat:@"%d",friend.userId]]) {
            conversationVC.title = friend.nickName;

        }
    }
    
    NSDictionary *parameters = @{
                                 @"t_uid":model.targetId
                                 };
    WEAKSELF
    [JDWNetworkHelper POST:SPURL_API_Black parameters:parameters success:^(id responseObject) {
        STRONGSELF
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil && [responseDic[@"data"][@"is_black"] boolValue]) {
            BOOL is_black = [responseDic[@"data"][@"is_black"]  boolValue];
            if (is_black) {
                [MBProgressHUD showAutoMessage:@"你们已互为黑名单"];
            }
        }else{
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
        

    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        JDWLog(@"%@",error.localizedDescription);
        [self.navigationController pushViewController:conversationVC animated:YES];
    }];
    
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *))completion{
    for (SPPersonModel *model in self.friends) {
        if ([userId isEqualToString:[NSString stringWithFormat:@"%d",model.userId]]) {
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:model.nickName portrait:model.avatar];
            return completion(userInfo);
        }
    }
    
}

@end
