//
//  SPPursuitController.m
//  SinglePark
//
//  Created by DBB on 2018/10/14.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPursuitController.h"
#import "SPPursuitListView.h"
#import "SPPursuitHomeView.h"
#import "SPPlayVideoController.h"

@interface SPPursuitController ()<UIScrollViewDelegate>
@property(nonatomic,strong) UISegmentedControl *segmentControl;
@property (nonatomic,strong)UIScrollView *pursuitScroll;
@property (nonatomic,strong)SPPursuitListView *pursuitMe; // 追我的人
@property (nonatomic, strong) SPPursuitHomeView *mePursuit;// 我追的人

@end

@implementation SPPursuitController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.segmentControl;
    [self.view addSubview:self.pursuitScroll];
    
    [self.pursuitScroll addSubview:self.pursuitMe];
    [self.pursuitScroll addSubview:self.mePursuit];
    
    self.hideNavigationLine = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)requestData {
    
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
    }
    return _pursuitScroll;
}

// 可用
- (SPPursuitListView *)pursuitMe{
    if (_pursuitMe == nil) {
        _pursuitMe = [[SPPursuitListView alloc] initWithFrame:self.pursuitScroll.bounds];
        _pursuitMe.promptArr = @[@"人数",@"人名片中显示",@"如果您关闭此项，您的个人名片中将不再显示您的追求者，默认开启。追我的人："];
        _pursuitMe.isme = YES;
        _pursuitMe.typede = PursuitTypeNone;

    }
    return _pursuitMe;
}

// 已用
//- (SPPursuitListView *)mePursuit{
//    if (_mePursuit == nil) {
//        _mePursuit = [[SPPursuitListView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, self.pursuitScroll.width, self.pursuitScroll.height)];
//        _mePursuit.promptArr = @[@"人数",@"珍惜每一个遇见的人。因此，“我追的人”在同一时间段，人数不能超过3人，如果您“追求”的人已经达到3人，出现新人时，请删除旧人（左滑删除）。"];
//        _mePursuit.isme = YES;
//        _mePursuit.typede = PursuitTypeNone;
//
//
//    }
//    return _mePursuit;
//}

- (SPPursuitHomeView *)mePursuit {
    if (!_mePursuit) {
        _mePursuit = [[SPPursuitHomeView alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW, kScreenH-kNavigationHeight)];
        WEAKSELF
        STRONGSELF
        _mePursuit.gobackBlcok = ^{
            SPPlayVideoController *play = [[SPPlayVideoController alloc] init];
            [strongSelf.navigationController pushViewController:play animated:YES];
        };
    }
    return _mePursuit;
}

//segment方法
- (void)chageSCVaule:(UISegmentedControl *)sc{
    [self.pursuitScroll setContentOffset:CGPointMake(sc.selectedSegmentIndex*kScreenWidth, 0) animated:YES];
}

#pragma mark - scrollView  代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.segmentControl.selectedSegmentIndex = scrollView.contentOffset.x/kScreenWidth;

}


@end
