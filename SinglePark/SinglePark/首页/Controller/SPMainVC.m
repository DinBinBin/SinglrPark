//
//  SPMainVC.m
//  SinglePark
//
//  Created by DBB on 2018/8/12.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPMainVC.h"
#import "SPCoverListView.h"

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


}


- (void)setNavView{
    self.navigationItem.titleView = self.segmentControl;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonLeftItemWithImageName:@"more" target:self action:@selector(selectTerm)];
    
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
    }
    return _leftView;
}

- (SPCoverListView *)rightView{
    if (_rightView == nil) {
        _rightView = [[SPCoverListView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, self.mainScrollView.width, self.mainScrollView.height)];
    }
    return _rightView;
}

@end
