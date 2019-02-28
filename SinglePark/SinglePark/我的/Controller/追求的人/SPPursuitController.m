//
//  SPPursuitController.m
//  SinglePark
//
//  Created by DBB on 2018/10/14.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPursuitController.h"
#import "SPPursuitListView.h"
#import "SPPlayVideoController.h"
#import "SPConversationViewController.h"
#import "SGTabBarController.h"
#import "SPChasingherController.h"

@interface SPPursuitController ()<UIScrollViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong) UISegmentedControl *segmentControl;
@property (nonatomic,strong)UIScrollView *pursuitScroll;
@property (nonatomic,strong)SPPursuitListView *pursuitMe; // 追我的人
@property (nonatomic, strong) SPPursuitListView *mePursuit;// 我追的人

@end

@implementation SPPursuitController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.segmentControl;
    [self.view addSubview:self.pursuitScroll];
    
    [self requestData];

    self.hideNavigationLine = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addRightItem) name:@"acceptClick" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"acceptClick" object:self];
}

- (void)eventBlock {
    WEAKSELF
    STRONGSELF
    self.pursuitMe.sendMessageBlock = ^(SPPersonModel * model) {
        [strongSelf sendMessageToUser:model];
    };
    
    self.pursuitMe.gohomeBlock = ^{
        SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
        KEYWINDOW.rootViewController = sgTabBar;
    };
    
    self.mePursuit.gohomeBlock = ^{
        SGTabBarController *sgTabBar = [[SGTabBarController alloc] init];
        KEYWINDOW.rootViewController = sgTabBar;
    };
    
    self.mePursuit.pursuitBlock = ^(SPPersonModel * model) {
        SPChasingherController *chasing = [[SPChasingherController alloc] init];
        chasing.model = model;
        [strongSelf.navigationController pushViewController:chasing animated:YES];
    };
    
    self.mePursuit.sendMessageBlock = ^(SPPersonModel * model) {
        [strongSelf sendMessageToUser:model];
    };

}

- (void)sendMessageToUser:(SPPersonModel *)model {
    SPConversationViewController *conversationVC = [[SPConversationViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = [NSString stringWithFormat:@"%d",model.userId];
    conversationVC.title = model.nickName;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)requestData {
    
    [self.pursuitScroll addSubview:self.pursuitMe];
    [self.pursuitScroll addSubview:self.mePursuit];

    [self eventBlock];

}


- (UISegmentedControl *)segmentControl{
    if(_segmentControl == nil){
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"确认我的人",@"我确认的人"]];
        _segmentControl.frame = CGRectMake((kScreenWidth-110)/2, 8, 220, 44-16);
        _segmentControl.selectedSegmentIndex = 0;
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

- (UIScrollView *)pursuitScroll{
    if (_pursuitScroll == nil) {
        _pursuitScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0 , kScreenWidth, kScreenHeight- kNavigationHeight)];
        _pursuitScroll.contentSize = CGSizeMake(kScreenWidth*2, _pursuitScroll.height);
        _pursuitScroll.pagingEnabled = YES;
        _pursuitScroll.delegate = self;
        _pursuitScroll.bounces = NO;
        _pursuitScroll.backgroundColor = [UIColor blackColor];
        _pursuitScroll.userInteractionEnabled = YES;
    }
    return _pursuitScroll;
}

// 追我的人
- (SPPursuitListView *)pursuitMe{
    if (_pursuitMe == nil) {
        _pursuitMe = [[SPPursuitListView alloc] initWithFrame:CGRectMake(0,0 , kScreenWidth, kScreenHeight- kNavigationHeight) viewType:SPPursuitMeViewType];
        
    }
    return _pursuitMe;
}

// 我追的人
- (SPPursuitListView *)mePursuit{
    if (_mePursuit == nil) {
        _mePursuit = [[SPPursuitListView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, self.pursuitScroll.width, self.pursuitScroll.height) viewType:SPMePursuitViewType];
        
    }
    return _mePursuit;
}


//segment方法
- (void)chageSCVaule:(UISegmentedControl *)sc{
    [self.pursuitScroll setContentOffset:CGPointMake(sc.selectedSegmentIndex*kScreenWidth, 0) animated:YES];
    if (sc.selectedSegmentIndex == 0) {
        if (self.pursuitMe.typede == PursuitTypeDetailAccept) {
            [self addRightItem];
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)addRightItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonLeftItemWithImageName:@"more" target:self action:@selector(selectCover)];

}

- (void)selectCover {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * nolike = [UIAlertAction actionWithTitle:@"不合适" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"noacceptClick" object:nil userInfo:nil]];
    }];
    
    [nolike setValue:TextMianColor forKey:@"_titleTextColor"];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:nolike];
    [alertController addAction:cancel];
    [self showDetailViewController:alertController sender:nil];
}

#pragma mark - scrollView  代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.segmentControl.selectedSegmentIndex = scrollView.contentOffset.x/kScreenWidth;

}



@end
