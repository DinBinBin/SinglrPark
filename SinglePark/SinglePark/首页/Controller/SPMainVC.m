//
//  SPMainVC.m
//  SinglePark
//
//  Created by DBB on 2018/8/12.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPMainVC.h"
#import "SPCoverListView.h"
#import "JDWPopMenuView.h"
#import "UITabBar+SPTabBar.h"
#import <RongIMKit/RongIMKit.h>


@interface SPMainVC ()<UIScrollViewDelegate>
@property(nonatomic,strong) UISegmentedControl *segmentControl;
@property (nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong)SPCoverListView *leftView;
@property (nonatomic,strong)SPCoverListView *rightView;

@end

@implementation SPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavView];
    
    WEAKSELF
    STRONGSELF
    [JDWNetworkHelper startMonitoringNetwork];
    [JDWNetworkHelper networkStatusWithBlock:^(JDWNetworkStatus status) {
        switch (status)
        {
            case JDWNetworkStatusUnknown:
                JDWLog(@"未知网络");
                [strongSelf requestUserInfo];
                break;
            case JDWNetworkStatusNotReachable:
                JDWLog(@"无网络");
                break;
            case JDWNetworkStatusReachableViaWWAN:
                JDWLog(@"手机自带网络");
                [strongSelf requestUserInfo];
                break;
            case JDWNetworkStatusReachableViaWiFi:
                JDWLog(@"WIFI");
                [strongSelf requestUserInfo];
                break;
        }
    }];

    if (![DBAccountInfo sharedInstance].isTouris) {
        [self refreshToken];
    }
    
    [self.tabBarController.tabBar showBadgeOnItemIndex:1 count:21];
    
    //获取融云未读消息
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
                                                    @(ConversationType_DISCUSSION),
                                                    @(ConversationType_CHATROOM),
                                                    @(ConversationType_GROUP),
                                                    @(ConversationType_APPSERVICE),
                                                    @(ConversationType_SYSTEM)]];
    NSLog(@"%d",count);
    
    [self getLocation];
}


- (void)requestUserInfo {
    WEAKSELF
    STRONGSELF
    [JDWNetworkHelper POST:PTURL_API_UserGet parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            SPPersonModel *model = [SPPersonModel modelWithJSON:responseDic[@"data"]];
            
            //保存用户信息
            [[DBAccountInfo sharedInstance].model yy_modelSetWithJSON:responseDic[@"data"]];
            [JDWUserInfoDB saveUserInfo:[DBAccountInfo sharedInstance].model];
            
            /** 注册融云 */
            [strongSelf registRYAPI:model.rc_token];
        }else{
//            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
    
}

- (void)registRYAPI:(NSString *)rcToken {
    [[RCIM sharedRCIM] initWithAppKey:RYAPPKey];
    
    // 登陆
    [[RCIM sharedRCIM] connectWithToken:rcToken success:^(NSString *userId) {
        JDWLog(@"登陆成功userid＝%@",userId);
        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:[DBAccountInfo sharedInstance].model.nickName portrait:[DBAccountInfo sharedInstance].model.avatar];
        // 设置消息体内是否携带用户信息
        [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    } error:^(RCConnectErrorCode status) {
        JDWLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        JDWLog(@"token错误");
    }];
    
    // 消息推送
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}


- (void)refreshToken {
    [JDWNetworkHelper POST:SPURL_API_Refresh parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;

        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            //保存token
            
            NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
            [userdef removeObjectForKey:isLogin];
            [userdef setObject:responseDic[@"data"][@"token"] forKey:isLogin];
            [DBAccountInfo sharedInstance].token = responseDic[@"data"][@"token"];
            [DBAccountInfo sharedInstance].islogin = YES;
        }else{
            [DBAccountInfo sharedInstance].islogin = NO;

        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)setNavView{
    self.navigationItem.titleView = self.segmentControl;
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonLeftItemWithImageName:@"more" target:self action:@selector(selectTerm)];
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.leftView];
    [self.mainScrollView addSubview:self.rightView];

//    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.edges.equalTo(self.view);
//        make.top.left.width.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
//
//    }];
//
//    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.width.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
////        make.edges.equalTo(self.view);
//    }];
//
//    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.top.equalTo(self.leftView);
//        make.left.equalTo(self.leftView.mas_right);
//    }];
//    self.leftView.backgroundColor = [UIColor redColor];
//    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth*2,self.mainScrollView.height);
}

//segment方法
- (void)chageSCVaule:(UISegmentedControl *)sc{
    [self.mainScrollView setContentOffset:CGPointMake(sc.selectedSegmentIndex*kScreenWidth, 0) animated:YES];
}
// 滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.segmentControl.selectedSegmentIndex = scrollView.contentOffset.x/kScreenWidth;
}

// 弹出筛选条件
- (void)selectTerm{
//    [JDWPopMenuView showWithItems:@[@{@"title":@"只看女生",@"imageName":@"iconWomen"},
//                                    @{@"title":@"只看男生",@"imageName":@"iconMen"},
//                                    @{@"title":@"查看全部",@"imageName":@"iconAll"},
//                                    @{@"title":@"取消",@"imageName":@"iconCancel"}
//                                    ]
//                            width:125
//                 triangleLocation:CGPointMake(kScreenW-40, kNavigationHeight)
//                           action:^(NSInteger index) {
//                               NSLog(@"点击了第%ld行",index);
//                           }];
}


- (UISegmentedControl *)segmentControl{
    if(_segmentControl == nil){
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"推荐",@"附近"]];
        _segmentControl.frame = CGRectMake((kScreenWidth-110)/2, 8, 140, 44-16);
        _segmentControl.selectedSegmentIndex = 0;
        UIFont *font = [UIFont boldSystemFontOfSize:17];   // 设置字体大小
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                                   forKey:NSFontAttributeName];
        [_segmentControl setTitleTextAttributes:attributes
                                            forState:UIControlStateNormal];
        
        _segmentControl.layer.masksToBounds = YES;
        _segmentControl.layer.cornerRadius = 14;
        _segmentControl.layer.borderWidth = 1;
        _segmentControl.tintColor = [UIColor whiteColor];
        _segmentControl.backgroundColor = [UIColor blackColor];
        _segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
        [_segmentControl addTarget:self action:@selector(chageSCVaule:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil){
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0 , kScreenWidth, kScreenHeight-49-64-KsafeTabIPhonex-KAddIPhonex)];
        _mainScrollView.contentSize = CGSizeMake(kScreenWidth*2,_mainScrollView.height);
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
    }
    return _mainScrollView;
}

- (SPCoverListView *)leftView{
    if (_leftView == nil) {
        _leftView = [[SPCoverListView alloc] initWithFrame:self.mainScrollView.bounds];
        _leftView.islocal = NO;
    }
    return _leftView;
}

- (SPCoverListView *)rightView{
    if (_rightView == nil) {
        _rightView = [[SPCoverListView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, self.mainScrollView.width, self.mainScrollView.height)];
        _rightView.islocal = YES;

    }
    return _rightView;
}

@end
