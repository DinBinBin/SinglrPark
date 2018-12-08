//
//  SPChatListViewController.m
//  SinglePark
//
//  Created by chensw on 2018/12/4.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SPChatListViewController.h"
#import "SPConversationViewController.h"


@interface SPChatListViewController ()

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

@end
