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
@property (nonatomic,strong)NSArray<RCConversationModel *> *modelArr;
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

- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    NSLog(@"会话列表:%@",dataSource);
    self.modelArr = dataSource.copy;
    
    return dataSource;
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
    conversationVC.title = @"会话窗口";
    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *))completion{
    
    if ([userId isEqualToString:@"1001"]) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:@"测试2" portrait:@"http://imgsrc.baidu.com/forum/w=580/sign=5566fdc475094b36db921be593cd7c00/f92ae850352ac65c74f36568f8f2b21192138a60.jpg"];
        return completion(userInfo);
    }else if ([userId isEqualToString:@"1000"]){
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:@"我小时候就很美" portrait:@"http://img181.poco.cn/mypoco/myphoto/20110509/19/56595788201105091919176805863526146_007.jpg"];
        completion(userInfo);
    }else if ([userId isEqualToString:@"1002"]){
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:@"今晚吃鸡" portrait:@"http://img181.poco.cn/mypoco/myphoto/20110509/19/56595788201105091919176805863526146_007.jpg"];
        completion(userInfo);
    }
}

@end
