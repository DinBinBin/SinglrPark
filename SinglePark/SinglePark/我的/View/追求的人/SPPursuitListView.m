//
//  SPPursuitListView.m
//  SinglePark
//
//  Created by DBB on 2018/10/21.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPursuitListView.h"
#import "SPPursuitHeadTabCell.h"
#import "SPPursuitMeModel.h"
#import "SPPursuitNoneTabCell.h"
#import "SPCoverTabCell.h"
#import "SPPursuitVoiceCell.h"
#import "SPPursuitButtonCell.h"
#import "OYCountDownManager.h"
#import <RongIMKit/RongIMKit.h>

NSString *const OYMultipleTableSource1 = @"OYMultipleTableSource1";
NSString *const OYMultipleTableSource2 = @"OYMultipleTableSource2";

@interface SPPursuitListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *pursuitStr;
@property (nonatomic,copy)NSString *pursuitNO;

@property (nonatomic,strong)NSMutableArray *dataArr;
//@property (nonatomic,strong)UIButton *hunterBtn; //逛逛公园
@property (nonatomic, strong) UILabel *tipLable; //状态提示
//@property (nonatomic, strong) SPPursuitButtonCell *timeCell; //倒计时
@property (nonatomic, strong) SPPursuitVoiceCell *vocieCell; //附加消息


@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger currentInt1; // 倒计时间
@property (nonatomic, assign) NSInteger currentInt2; // 倒计时间

@property (nonatomic, strong) OYModel *OYModel1;
@property (nonatomic, strong) OYModel *OYModel2;


@property (nonatomic, strong) SPPursuitMeModel *pursuitMeModel;
@property (nonatomic, strong) SPPursuitMeModel *mePursuitModel;

@end

@implementation SPPursuitListView

- (id)initWithFrame:(CGRect)frame  viewType:(SPPursuitViewType)type{
    if (self = [super initWithFrame:frame]) {
        
        [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        // 启动倒计时管理
        [kCountDownManager start];
        // 增加倒计时源
        [kCountDownManager addSourceWithIdentifier:OYMultipleTableSource1];
        [kCountDownManager addSourceWithIdentifier:OYMultipleTableSource2];
        self.viewType = type;
        
        if (type == SPPursuitMeViewType) {
            self.typede = PursuitTypeDetailAccept;
        }else {
            self.typede = PursuitTypeDetailAccept;

        }
        
        [self requestData];
    }
    return self;
}

- (void)dealloc {
    // 废除定时器
    [kCountDownManager invalidate];
    // 清空时间差
    [kCountDownManager reload];
}

- (void)clearTimer {
    if (self.viewType == SPPursuitMeViewType) {
        // 模拟网络请求
        self.OYModel1 = nil;
        // 调用reload, 指定identifier
        [kCountDownManager reloadSourceWithIdentifier:OYMultipleTableSource1];
    }

}


- (void)setUpCellUIWith:(SPPursuitButtonCell *)upCell downCell:(SPPursuitButtonCell *)downCell {
    
    if (self.viewType == SPPursuitMeViewType) {//追我的人
        
        switch (self.typede) {
            case SPPursuitTypeNotStated: //未表态
            {
                self.tipLable.text = @"恭喜，有人追你啦，请在倒计时之前处理请求，否则系统会自动拒绝！";
                
                self.currentInt1 = 24*60*60;
                self.vocieCell.voiceUrl = @"http://images.wuchenge.com/Fi7DXo_EdKon0aNE1dxRbV3a9lNF";

                self.vocieCell.model = self.OYModel1;
                WEAKSELF
                STRONGSELF
                [self.vocieCell setCountDownZero:^(OYModel * timeOutModel) {
                    if (!timeOutModel.timeOut) {
                        strongSelf.typede = SPPursuitTypeOutTime;
                        [strongSelf.listTabView reloadData];
                    }
                    // 标志
                    timeOutModel.timeOut = YES;
                }];
                
                [upCell.mybutton setTitle:@"接受" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                
                [upCell.mybutton addTarget:self action:@selector(acceptClick:) forControlEvents:UIControlEventTouchUpInside];
                [downCell.mybutton addTarget:self action:@selector(noAccpet:) forControlEvents:UIControlEventTouchUpInside];

                break;
            }
            case SPPursuitTypeOutTime://未表态而且超时了
                self.tipLable.text = @"由于您未及时处理，请求已过有效期。到现在为止还未出现新的追求者";

                break;
                
            case SPPursuitTypeRefuse:
                self.tipLable.text = @"您已拒绝了ta，到现在为止还未出现新的追求者";

                
                break;
            case PursuitTypeDetailAccept:
                self.tipLable.text = @"您选择了接受，多主动沟通吧^_^";
                upCell.mybutton.enabled = YES;
                [upCell.mybutton setTitle:@"发信息" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                
                [upCell.mybutton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
                [downCell.mybutton addTarget:self action:@selector(noAccpet:) forControlEvents:UIControlEventTouchUpInside];
                break;
                
            default:
                break;
        }
        
        
    }else{//我追的人
        switch (self.typede) {
            case SPPursuitTypeNotStated: //未表态
            {
                self.tipLable.text = @"请等待对方回应";
                
                [upCell.mybutton setEnabled:NO];
                
                self.currentInt2 = 12*60*60;
                upCell.model = self.OYModel2;
                WEAKSELF
                STRONGSELF
                [upCell setCountDownZero:^(OYModel * timeOutModel) {
                    if (!timeOutModel.timeOut) {
                        NSLog(@"SingleTableVC---时间到了");
                        strongSelf.typede = SPPursuitTypeOutTime;
                        [strongSelf.listTabView reloadData];
                    }
                    // 标志
                    timeOutModel.timeOut = YES;
                }];
                
                break;
            }
            case SPPursuitTypeOutTime://未表态而且超时了
                self.tipLable.text = @"超时，系统自动拒绝";
                [upCell.mybutton setEnabled:YES];
                [upCell.mybutton setTitle:@"追她" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                [upCell.mybutton addTarget:self action:@selector(pursuitClick:) forControlEvents:UIControlEventTouchUpInside];
                [downCell.mybutton addTarget:self action:@selector(noAccpet:) forControlEvents:UIControlEventTouchUpInside];

                break;
                
            case SPPursuitTypeRefuse:
                self.tipLable.text = @"对方觉得你俩不合适哎";
                upCell.mybutton.enabled = YES;
                [upCell.mybutton setTitle:@"追她" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                [upCell.mybutton addTarget:self action:@selector(pursuitClick:) forControlEvents:UIControlEventTouchUpInside];
                [downCell.mybutton addTarget:self action:@selector(noAccpet:) forControlEvents:UIControlEventTouchUpInside];

                break;
            case PursuitTypeDetailAccept:
                self.tipLable.text = @"对方已接受";
                upCell.mybutton.enabled = YES;
                [upCell.mybutton setTitle:@"发信息" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                
                [upCell.mybutton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
                [downCell.mybutton addTarget:self action:@selector(noAccpet:) forControlEvents:UIControlEventTouchUpInside];

                break;
                
            default:
                break;
        }
        
    }
}

- (void)requestData {
    WEAKSELF
    STRONGSELF

    [MBProgressHUD showLoadToView:self];
    
    NSString *url = self.viewType == SPPursuitMeViewType ? SPURL_API_Follow_tos : SPURL_API_Follow_froms;
    [JDWNetworkHelper POST:url parameters:@{@"page":@"1",@"limit":@"10"} success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *items = responseDic[@"data"][@"items"];
            if (items.count > 0) {
                NSDictionary *item = items.firstObject;
                self.pursuitMeModel = [SPPursuitMeModel modelWithJSON:item];
                self.typede = self.pursuitMeModel.status;
            }
            
            
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        [MBProgressHUD hideHUDForView:strongSelf];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD hideHUDForView:strongSelf];
        
    }];
}

#pragma mark ----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.typede == SPPursuitTypeNone) {
        return 2;
    }
    
    if (self.viewType == SPPursuitMeViewType) {//追我的人
        if (self.typede == SPPursuitTypeNotStated) {
            return 5;
        }
        if (self.typede == PursuitTypeDetailAccept) {
            return 5;
        }
        
        return 2;
    }else if (self.viewType == SPMePursuitViewType) {//我追的人
        
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.typede == SPPursuitTypeNone) {//没有状态
        if (indexPath.section == 0) {
            SPPursuitNoneTabCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pursuitNO forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.viewType = self.viewType;
            return cell;
        }
        SPPursuitButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPPursuitButtonCell" forIndexPath:indexPath];
        [cell.mybutton setTitle:@"逛逛公园" forState:UIControlStateNormal];
        [cell.mybutton addTarget:self action:@selector(gohome:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    if (self.viewType == SPPursuitMeViewType) {//追我的人
        if (indexPath.section == 0) {
            SPCoverTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
            cell.model = [DBAccountInfo sharedInstance].model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLab.hidden = YES;
            cell.contentView.backgroundColor = [UIColor blackColor];
            return cell;
        }else if (indexPath.section == 1) {// 提示状态文字
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.tipLable];
            [self setUpCellUIWith:nil downCell:nil];

            return cell;
            
        }else if (indexPath.section == 2) {//附加消息
            if (self.typede == PursuitTypeDetailAccept) {
                return [UITableViewCell new];
            }
            SPPursuitVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPPursuitVoiceCell" forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.vocieCell = cell;
            return cell;
            
        }else if (indexPath.section == 3) { //接受
            
            SPPursuitButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPPursuitButtonCell" forIndexPath:indexPath];
            [cell.mybutton setTitle:@"接受" forState:UIControlStateNormal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [self setUpCellUIWith:cell downCell:nil];

            return cell;
            
        }else{//拒绝
            
            SPPursuitButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPPursuitButtonCell" forIndexPath:indexPath];
            [cell.mybutton setTitle:@"拒绝" forState:UIControlStateNormal];
            [cell.mybutton setTitleColor:ThemeColor forState:UIControlStateNormal];
            [cell.mybutton setBackgroundColor:[UIColor whiteColor]];
            cell.mybutton.layer.borderWidth = 1;
            cell.mybutton.layer.borderColor = ThemeColor.CGColor;
            [self setUpCellUIWith:nil downCell:cell];
            return cell;
        }
        
    }else {//我追的人
        
        if (indexPath.section == 0) {
            SPCoverTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
            cell.model = [DBAccountInfo sharedInstance].model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLab.hidden = YES;
            cell.contentView.backgroundColor = [UIColor blackColor];
            return cell;
        }else if (indexPath.section == 1) {// 提示状态文字
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.tipLable];
            [self setUpCellUIWith:nil downCell:nil];

            return cell;
            
        }else if (indexPath.section == 2) { //倒计时按钮
            SPPursuitButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPPursuitButtonCell" forIndexPath:indexPath];
            cell.mybutton.enabled = NO;
            [cell.mybutton setTitle:@"12小时0分0秒" forState:UIControlStateDisabled];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            self.timeCell = cell;
            [self setUpCellUIWith:cell downCell:nil];
            return cell;
            
        }else{//逛逛公园
            SPPursuitButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPPursuitButtonCell" forIndexPath:indexPath];
            [cell.mybutton setTitle:@"逛逛公园" forState:UIControlStateNormal];
            [cell.mybutton setTitleColor:ThemeColor forState:UIControlStateNormal];
            [cell.mybutton setBackgroundColor:[UIColor whiteColor]];
            cell.mybutton.layer.borderWidth = 1;
            cell.mybutton.layer.borderColor = ThemeColor.CGColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self setUpCellUIWith:nil downCell:cell];
            [cell.mybutton addTarget:self action:@selector(gohome:) forControlEvents:UIControlEventTouchUpInside];

            return cell;
        }
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewType == SPPursuitMeViewType) {
        if (self.typede == PursuitTypeDetailAccept) {
            if (indexPath.section == 2) {
                return 0.01; //将倒计时视图隐藏掉
            }
        }
    }
    
    
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row - self.promptArr.count >= 0) {
//        SPBusinessCardController *business = [[SPBusinessCardController alloc] init];
//        business.model = self.dataArr[indexPath.row - self.promptArr.count];
    }
    
}

#pragma mark - action
//接受
- (void)acceptClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"接受"]) {
        [self clearTimer];
        if (self.typede == SPPursuitTypeNotStated) {
            [[SPFriendDBManger shareInstance] saveFriendToDB:self.pursuitMeModel.fromUser];
            
            self.typede = PursuitTypeDetailAccept;
            
            RCTextMessage *txt = [RCTextMessage messageWithContent:@"我已经成为你的好友了，咱们开始聊天吧！"];
            
            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:@"9" content:txt pushContent:nil pushData:nil success:^(long messageId) {
                NSLog(@"messageId:%ld",messageId);
            } error:^(RCErrorCode nErrorCode, long messageId) {
                
            }];
            
            [self.listTabView reloadData];
        }
    }
}

//发消息
- (void)sendMessage {
    if (self.typede == PursuitTypeDetailAccept) {
        if (self.sendMessageBlock) {
            if (self.viewType == SPPursuitMeViewType) {
                self.sendMessageBlock(self.pursuitMeModel.fromUser);
            }else{
                self.sendMessageBlock(self.pursuitMeModel.toUser);
            }
        }
    }
    
    
}

//追她
- (void)pursuitClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"追她"]) {
        if (self.pursuitBlock) {
            self.pursuitBlock();
        }
    }
}

//不合适,删除会话列表
- (void)noAccpet:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"不合适"]) {
        if (self.viewType == SPPursuitMeViewType) {
            self.typede = SPPursuitTypeRefuse;
            [self.listTabView reloadData];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:[NSString stringWithFormat:@"%d",self.pursuitMeModel.fromUser.userId]];
            [[SPFriendDBManger shareInstance] deleteFriend:self.pursuitMeModel.fromUser.userId];
        }else{
#warning 这里需要上传数据接口，告诉服务器拒绝了对方
            self.typede = SPPursuitTypeNone;
            [self.listTabView reloadData];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:[NSString stringWithFormat:@"%d",self.mePursuitModel.toUser.userId]];
            [[SPFriendDBManger shareInstance] deleteFriend:self.mePursuitModel.toUser.userId];
        }
        
    }
    
}

- (void)gohome:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"逛逛公园"]) {
        if (self.gohomeBlock) {
            self.gohomeBlock();
        }
    }
}


#pragma mark - 懒加载

- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        _listTabView.tableFooterView = [[UIView alloc] init];
        self.pursuitStr = @"pursuitStr";
        self.pursuitNO = @"pursuitNO";
        [_listTabView registerClass:[SPPursuitHeadTabCell class] forCellReuseIdentifier:self.pursuitStr];
        [_listTabView registerClass:[SPPursuitNoneTabCell class] forCellReuseIdentifier:self.pursuitNO];
        [_listTabView registerClass:[SPCoverTabCell class] forCellReuseIdentifier:@"videoCell"];
        [_listTabView registerNib:[UINib nibWithNibName:@"SPPursuitVoiceCell" bundle:nil] forCellReuseIdentifier:@"SPPursuitVoiceCell"];
        [_listTabView registerNib:[UINib nibWithNibName:@"SPPursuitButtonCell" bundle:nil] forCellReuseIdentifier:@"SPPursuitButtonCell"];

        
        _listTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTabView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigbackground"]];
        [self addSubview:_listTabView];
    }
    return _listTabView;
}


- (UILabel *)tipLable {
    if (!_tipLable) {
        _tipLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-20, 44)];
        _tipLable.text = @"请等待对方回应";
        _tipLable.textColor = SecondWordColor;
        _tipLable.font = Font16;
        _tipLable.backgroundColor = [UIColor clearColor];
        _tipLable.numberOfLines = 0;
    }
    return _tipLable;
}

- (OYModel *)OYModel1 {
    if (!_OYModel1) {
        _OYModel1 = [[OYModel alloc] init];
        _OYModel1.count = self.currentInt1;
    }
    return _OYModel1;
}

- (OYModel *)OYModel2 {
    if (!_OYModel2) {
        _OYModel2 = [[OYModel alloc] init];
        _OYModel2.count = self.currentInt2;
    }
    return _OYModel2;
}




@end
