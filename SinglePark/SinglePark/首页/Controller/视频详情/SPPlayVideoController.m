
//
//  SPPlayVideoController.m
//  SinglePark
//
//  Created by DBB on 2018/10/4.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPlayVideoController.h"
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#import "SPCoverModel.h"
#import "PlayerScrollView.h"
#import "KJPushAnimator.h"

@interface SPPlayVideoController ()<UINavigationControllerDelegate>
//播放器，数据源
@property (nonatomic,strong)PlayerScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *videArr;


@end

@implementation SPPlayVideoController

- (PlayerScrollView *)scrollView{
    if (!_scrollView) {
        self.scrollView =[[PlayerScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight+0)];
        __weak typeof(self) weakSelf =self;
        _scrollView.passCurrentPlayerIndex = ^(NSInteger index) {
            //此时需要讲之前的播放视频的view 隐藏掉，只显示占位图
            if (index == self.datasource.count - 1 ) {
                NSLog(@"此处调用加载方法，加载最新的视频信息");
                [weakSelf loadMoreData];
            }
            if(index == 0){
//                [weakSelf loadData];
            }else{
                
            }
        };
        [self.view addSubview:self.scrollView];
    }
    return _scrollView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView registNotification];
//    [self.scrollView.player play];
//    self.originalDelegate = self.navigationController.delegate;
    self.navigationController.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scrollView.player pause];
    [self.scrollView removeNOtification];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载视频数据源
//    [self loadData];
    //加载视频，准备播放
    self.videArr = [NSMutableArray array];
    if (self.datasource.count) {
        for (SPPersonModel *model in self.datasource) {
            if (model.first_video) {
                [self.videArr addObject:model];
            }
        }
        
        [self.scrollView setMovePlayerWithInfoModelArray:self.videArr withPlayIndex:self.selectIndex];

    }
    

    UIButton *backBtn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn1.frame = CGRectMake(0, 25, 50, 50);
    [backBtn1 setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(handle_backBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn1];
    

    //添加刷新控件
//    [self.view ar_addAndroidRefreshWithDelegate:self];
//    self.view.ar_headerView.refreshOffset = 64.0f;
    
//    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    self.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoredata)];

}

- (void)handle_backBtn{
    [self.scrollView.player stop];
    self.scrollView.player = nil;
    [self.navigationController popViewControllerAnimated:YES];

}
//加载数据信息
- (void)loadData{
    NSString *choose;
    switch (self.choosetype) {
        case 1:
            choose = @"1";
            break;
        case 2:
            choose = @"2";
            
            break;
        case 3:
            choose = @"3";
            
            break;
        default:
            break;
    }
    
    NSString *sex = @"";
    int sexNum = [JDWUserInfoDB userInfo].sex;
    if (sexNum == 1) {
        sex = @"2";
    }else if (sexNum == 2) {
        sex = @"1";
    }else {
        sex = @"0";
    }

    self.videArr = [NSMutableArray array];
    //    获取视频列表
    self.num ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.num],@"page",@"10",@"limit",sex,@"sex", nil];
    if (self.islocal) {  //是本地
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.longitude] forKey:@"longitude"];
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.latitude] forKey:@"latitude"];
        
    }
    
    
    [JDWNetworkHelper POST:PTURL_API_Index parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *arr = [[SPPersonModel modelArrayWithJSON:responseDic[@"data"][@"items"]] mutableCopy];
            if (arr.count) {
                for (SPPersonModel *model in arr) {
                    if (model.first_video) {
                        [self.videArr addObject:model];
                    }
                }
                [self.scrollView setMovePlayerWithInfoModelArray:self.videArr withPlayIndex:0];
            }
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
        [self.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [self.scrollView.mj_header endRefreshing ];
    }];

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController  setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)loadMoreData{

    NSString *choose;
    switch (self.choosetype) {
        case 1:
            choose = @"1";
            break;
        case 2:
            choose = @"2";
            
            break;
        case 3:
            choose = @"3";
            
            break;
        default:
            break;
    }
    
    NSString *sex = @"";
    int sexNum = [JDWUserInfoDB userInfo].sex;
    if (sexNum == 1) {
        sex = @"2";
    }else if (sexNum == 2) {
        sex = @"1";
    }else {
        sex = @"0";
    }
    
    self.num ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.num],@"page",@"10",@"limit",sex,@"sex", nil];
    //    获取视频列表
    if (self.islocal) {  //是本地
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.longitude] forKey:@"longitude"];
        [params setObject:[NSString stringWithFormat:@"%f",[DBAccountInfo sharedInstance].model.latitude] forKey:@"latitude"];
        
    }
    
    
    
    [JDWNetworkHelper POST:PTURL_API_Index parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *arr = [[SPPersonModel modelArrayWithJSON:responseDic[@"data"][@"items"]] mutableCopy];
            if (arr.count) {
                for (SPPersonModel *model in arr) {
                    if (model.first_video) {
                        [self.videArr addObject:model];
                    }
                }
                [self.scrollView addNewData:self.videArr];
            }

        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
        

        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        
    }];
    

    
}


@end
