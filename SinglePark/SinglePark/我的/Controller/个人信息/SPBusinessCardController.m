//
//  SPBusinessCardController.m
//  SinglePark
//
//  Created by DBB on 2018/10/5.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPBusinessCardController.h"
#import "SPCardTabCell.h"
#import "SPCardVideoTabCell.h"
#import "SPChasingherController.h"
#import "LCLoginController.h"
#import "SPPlayVideoController.h"
#import "SPPursuitButtonCell.h"
#import "OYCountDownManager.h"


@interface SPBusinessCardController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,copy)NSString *coverStr2;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)SPPersonModel *personmodel;
//@property (nonatomic,strong)UIButton *hunterBtn;
@property (nonatomic, assign) NSInteger currentInt; // 倒计时间
@property (nonatomic, strong) OYModel *OYModel;

@end

@implementation SPBusinessCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.nickName;
    
    
    // 增加倒计时源
    [kCountDownManager addSourceWithIdentifier:[NSString stringWithFormat:@"%d",self.model.userId]];
    
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.hideNavigationLine = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestFollowTos];

}

- (void)dealloc {
    [kCountDownManager removeSourceWithIdentifier:[NSString stringWithFormat:@"%d",self.model.userId]];
    [kCountDownManager invalidate];
    // 清空时间差
    [kCountDownManager reload];
}

- (void)requestFollowTos {
    WEAKSELF
    STRONGSELF
    if (!self.model.userId) {
        return;
    }
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:SPURL_API_Follow_otherTos parameters:@{@"page":@"1",@"limit":@"10",@"user_id":[NSString stringWithFormat:@"%d",self.model.userId]} success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *items = responseDic[@"data"][@"items"];
            if (items.count > 0) {
//                self.currentInt = 12*60*60;
                // 启动倒计时管理
                NSDictionary *item = items.firstObject;
                self.currentInt = [ProjectHelp transTotimeSp:item[@"created_at"]];
                [kCountDownManager start];
                
                SPPersonModel *model = [SPPersonModel modelWithJSON:item[@"from_user"]];
                strongSelf.model.number = @[model];
                [strongSelf.listTabView reloadData];
            }
            
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        [MBProgressHUD hideHUDForView:strongSelf.view];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD hideHUDForView:strongSelf.view];
        
    }];
}

- (void)pursiutClick {
    if (![DBAccountInfo sharedInstance].islogin) {
        LCLoginController *tourist = [[LCLoginController alloc] init];
        tourist.iswelecome = NO;
        [self.navigationController pushViewController:tourist animated:YES];
        return;
    }

    SPChasingherController *chasing = [[SPChasingherController alloc] init];
    chasing.model = self.model;
    [self.navigationController pushViewController:chasing animated:YES];
}

#pragma mark ----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SPCardTabCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.coverStr forIndexPath:indexPath];
        cell.isMine = NO;
        cell.model = self.model;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section == 1) {
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        [cell.contentView addSubview:self.hunterBtn];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SPPursuitButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPPursuitButtonCell" forIndexPath:indexPath];
        cell.mybutton.enabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftCons.constant = 10;
        cell.rightCons.constant = 10;
        self.OYModel.count = self.currentInt;

        cell.model = self.OYModel;
        WEAKSELF
        STRONGSELF
        typeof(cell) __weak weakCell = cell;
        [cell setCountDownZero:^(OYModel * timeOutModel) {
            if (!timeOutModel.timeOut) {
                NSLog(@"SingleTableVC---时间到了");
                [weakCell.mybutton setEnabled:YES];
                [weakCell.mybutton setTitle:@"追她" forState:UIControlStateNormal];

            }
            // 标志
            timeOutModel.timeOut = YES;
        }];
        
        [cell.mybutton addTarget:self action:@selector(pursiutClick) forControlEvents:UIControlEventTouchUpInside];
    
        return cell;
    }else{
        
        SPCardVideoTabCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.coverStr2 forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.coverModel = self.model.first_video;
    
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (self.model.first_video) {
            SPPlayVideoController *play = [[SPPlayVideoController alloc] init];
            play.selectIndex = indexPath.row;
            play.datasource = @[self.model].mutableCopy;
            play.choosetype = self.model.sex;
            play.islocal = NO;
            [self.navigationController pushViewController:play animated:YES];
        }
    }else if(indexPath.section == 1){
        if (!self.model.number) {
            SPChasingherController *chasing = [[SPChasingherController alloc] init];
            chasing.model = self.model;
            [self.navigationController pushViewController:chasing animated:YES];
        }
    }
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        _listTabView.tableFooterView = [UIView new];
        self.coverStr = @"coverId";
        [_listTabView registerClass:[SPCardTabCell class] forCellReuseIdentifier:self.coverStr];
        self.coverStr2 = @"coverId2";
        [_listTabView registerNib:[UINib nibWithNibName:@"SPPursuitButtonCell" bundle:nil] forCellReuseIdentifier:@"SPPursuitButtonCell"];

        [_listTabView registerClass:[SPCardVideoTabCell class] forCellReuseIdentifier:self.coverStr2];
        _listTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTabView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigbackground2"]];
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}
//
//- (UIButton *)hunterBtn{
//    if (_hunterBtn == nil) {
//        _hunterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _hunterBtn.frame = CGRectMake(10, 0, kScreenWidth-20, 44);
//        [_hunterBtn setCornerRadius:5];
//        _hunterBtn.backgroundColor = ThemeColor;
//        [_hunterBtn setTitle:@"追她" forState:UIControlStateNormal];
//        WEAKSELF
//        STRONGSELF
//        [_hunterBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            if (![DBAccountInfo sharedInstance].islogin) {
//                LCLoginController *tourist = [[LCLoginController alloc] init];
//                tourist.iswelecome = NO;
//                [strongSelf.navigationController pushViewController:tourist animated:YES];
//                return;
//            }
//
//            SPChasingherController *chasing = [[SPChasingherController alloc] init];
//            chasing.model = strongSelf.model;
//            [strongSelf.navigationController pushViewController:chasing animated:YES];
//        }];
//    }
//    return  _hunterBtn;
//}

- (OYModel *)OYModel {
    if (!_OYModel) {
        _OYModel = [[OYModel alloc] init];
    }
    return _OYModel;
}

@end
