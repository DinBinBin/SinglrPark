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
#import <RongIMKit/RongIMKit.h>

@interface SPPursuitController ()<UIScrollViewDelegate>
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)eventBlock {
    self.pursuitMe.acceptBlock = ^{
        RCTextMessage *txt = [RCTextMessage messageWithContent:@"hello"];
        
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:@"8" content:txt pushContent:nil pushData:nil success:^(long messageId) {
            NSLog(@"messageId:%ld",messageId);
        } error:^(RCErrorCode nErrorCode, long messageId) {
            
        }];
    };
}

- (void)requestData {
    
    [self.pursuitScroll addSubview:self.pursuitMe];
    [self.pursuitScroll addSubview:self.mePursuit];

    [self eventBlock];

}


- (UISegmentedControl *)segmentControl{
    if(_segmentControl == nil){
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"追我的人",@"我追的人"]];
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

//- (SPPursuitHomeView *)mePursuit {
//    if (!_mePursuit) {
//        _mePursuit = [[SPPursuitHomeView alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW, 750)];
//        WEAKSELF
//        STRONGSELF
//        _mePursuit.goVideoBlcok = ^{
//            SPPlayVideoController *play = [[SPPlayVideoController alloc] init];
//            [strongSelf.navigationController pushViewController:play animated:YES];
//        };
//
//    }
//    return _mePursuit;
//}

//segment方法
- (void)chageSCVaule:(UISegmentedControl *)sc{
    [self.pursuitScroll setContentOffset:CGPointMake(sc.selectedSegmentIndex*kScreenWidth, 0) animated:YES];

}

#pragma mark - scrollView  代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.segmentControl.selectedSegmentIndex = scrollView.contentOffset.x/kScreenWidth;

}



@end
