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


@interface SPBusinessCardController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,copy)NSString *coverStr2;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)SPPersonModel *personmodel;
@property (nonatomic,strong)UIButton *hunterBtn;
@end

@implementation SPBusinessCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.nickName;
    
    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.hideNavigationLine = YES;
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
        cell.model =  self.model;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.contentView addSubview:self.hunterBtn];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

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
        [_listTabView registerClass:[SPCardVideoTabCell class] forCellReuseIdentifier:self.coverStr2];
        _listTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTabView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigbackground2"]];
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}

- (UIButton *)hunterBtn{
    if (_hunterBtn == nil) {
        _hunterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hunterBtn.frame = CGRectMake(10, 0, kScreenWidth-20, 44);
        [_hunterBtn setCornerRadius:5];
        _hunterBtn.backgroundColor = ThemeColor;
        [_hunterBtn setTitle:@"追她" forState:UIControlStateNormal];
        WEAKSELF
        STRONGSELF
        [_hunterBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (![DBAccountInfo sharedInstance].islogin) {
                LCLoginController *tourist = [[LCLoginController alloc] init];
                tourist.iswelecome = NO;
                [strongSelf.navigationController pushViewController:tourist animated:YES];
                return;
            }
            
            SPChasingherController *chasing = [[SPChasingherController alloc] init];
            chasing.model = strongSelf.model;
            [strongSelf.navigationController pushViewController:chasing animated:YES];
        }];
    }
    return  _hunterBtn;
}

@end
