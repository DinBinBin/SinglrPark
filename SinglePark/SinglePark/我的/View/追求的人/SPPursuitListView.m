//
//  SPPursuitListView.m
//  SinglePark
//
//  Created by DBB on 2018/10/21.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPursuitListView.h"
#import "SPPursuitHeadTabCell.h"
//#import "SPBusinessCardController.h"
#import "SPPursuitNoneTabCell.h"
#import "SPCoverTabCell.h"
#import "SPPursuitVoiceCell.h"
#import "SPPursuitButtonCell.h"
#import "OYCountDownManager.h"
#import <RongIMKit/RongIMKit.h>


@interface SPPursuitListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *pursuitStr;
@property (nonatomic,copy)NSString *pursuitNO;

@property (nonatomic,strong)NSMutableArray *dataArr;
//@property (nonatomic,strong)UIButton *hunterBtn; //逛逛公园
@property (nonatomic, strong) UILabel *tipLable; //状态提示
@property (nonatomic, strong) SPPursuitButtonCell *timeCell; //倒计时
@property (nonatomic, strong) SPPursuitVoiceCell *vocieCell; //附加消息


@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger currentInt; // 倒计时间

@property (nonatomic, strong) SPPersonModel *model;
@end

@implementation SPPursuitListView

- (id)initWithFrame:(CGRect)frame  viewType:(SPPursuitViewType)type{
    if (self = [super initWithFrame:frame]) {
        
        [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        // 启动倒计时管理
        [kCountDownManager start];
        self.viewType = type;
        
        if (type == SPPursuitMeViewType) {
            self.typede = SPPursuitTypeNotStated;
        }else {
            self.typede = SPPursuitTypeNotStated;

        }
        
        [self requestData];
    }
    return self;
}

- (void)dealloc {
    [self clearTimer];
}

- (void)clearTimer {
    // 废除定时器
    [kCountDownManager invalidate];
    // 清空时间差
    [kCountDownManager reload];
}


- (void)setUpCellUIWith:(SPPursuitButtonCell *)upCell downCell:(SPPursuitButtonCell *)downCell {
    
    if (self.viewType == SPPursuitMeViewType) {//追我的人
        
        switch (self.typede) {
            case SPPursuitTypeNotStated: //未表态
            {
                self.tipLable.text = @"恭喜，有人追你拉，请在倒计时之前处理请求，否则系统会自动拒绝！";
                
                self.currentInt = 12*60*60;
//                [self updateTimer:self.timer];
//                [self timeOfScrollView];
                OYModel *model = [[OYModel alloc] init];
                model.count = self.currentInt;
                self.vocieCell.model = model;
                [self.vocieCell setCountDownZero:^(OYModel * timeOutModel) {
                    if (!timeOutModel.timeOut) {
                        NSLog(@"SingleTableVC--%@--时间到了", timeOutModel.title);
                    }
                    // 标志
                    timeOutModel.timeOut = YES;
                }];
                
                
                [upCell.mybutton setTitle:@"接受" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                
                [upCell.mybutton addTarget:self action:@selector(acceptClick) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            }
            case SPPursuitTypeOutTime://未表态而且超时了
                self.tipLable.text = @"由于您未及时处理，请求已过有效期。到现在为止还未出现新的追求者";
                upCell.mybutton.enabled = YES;
                [upCell.mybutton setTitle:@"追她" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                
                break;
                
            case SPPursuitTypeRefuse:
                self.tipLable.text = @"您已拒绝了ta，到现在为止还未出现新的追求者";
                upCell.mybutton.enabled = YES;
                [upCell.mybutton setTitle:@"追她" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                
                break;
            case PursuitTypeDetailAccept:
                self.tipLable.text = @"您选择了接受，多主动沟通吧";
                upCell.mybutton.enabled = YES;
                [upCell.mybutton setTitle:@"发信息" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                
                [upCell.mybutton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
                [downCell.mybutton addTarget:self action:@selector(noAccpet) forControlEvents:UIControlEventTouchUpInside];
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
                
                self.currentInt = 12*60*60;
//                [self updateTimer:self.timer];
                
                OYModel *model = [[OYModel alloc] init];
                model.count = self.currentInt;
                self.timeCell.model = model;
                [self.timeCell setCountDownZero:^(OYModel * timeOutModel) {
                    if (!timeOutModel.timeOut) {
                        NSLog(@"SingleTableVC--%@--时间到了", timeOutModel.title);
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
                
                break;
                
            case SPPursuitTypeRefuse:
                self.tipLable.text = @"对方觉得你俩不合适哎";
                upCell.mybutton.enabled = YES;
                [upCell.mybutton setTitle:@"追她" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                
                break;
            case PursuitTypeDetailAccept:
                self.tipLable.text = @"对方已接受";
                upCell.mybutton.enabled = YES;
                [upCell.mybutton setTitle:@"发信息" forState:UIControlStateNormal];
                [downCell.mybutton setTitle:@"不合适" forState:UIControlStateNormal];
                
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

    [JDWNetworkHelper POST:SPURL_API_info parameters:@{@"user_id":@"8"} success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            SPPersonModel *model = [SPPersonModel modelWithJSON:responseDic[@"data"]];
            self.model = model;
            
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        [MBProgressHUD hideHUDForView:strongSelf];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
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
            self.timeCell = cell;
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
    if (self.typede == PursuitTypeDetailAccept) {
        if (indexPath.section == 2) {
            return 0.01;
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
- (void)acceptClick {
    [self clearTimer];
    if (self.typede == SPPursuitTypeNotStated) {
        [[SPFriendDBManger shareInstance] saveFriendToDB:self.model];
        
        self.typede = PursuitTypeDetailAccept;
        
        RCTextMessage *txt = [RCTextMessage messageWithContent:@"我已经成为你的好友了，咋们开始聊天吧！"];
        
        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:@"8" content:txt pushContent:nil pushData:nil success:^(long messageId) {
            NSLog(@"messageId:%ld",messageId);
        } error:^(RCErrorCode nErrorCode, long messageId) {
            
        }];
        
        [self.listTabView reloadData];
    }
    
    
}
//发消息
- (void)sendMessage {
    if (self.typede == PursuitTypeDetailAccept) {
        if (self.sendMessageBlock) {
            self.sendMessageBlock(self.model);
        }
    }
    
    
}

//不合适,删除会话列表
- (void)noAccpet {
    
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:[NSString stringWithFormat:@"%d",self.model.userId]];
    [[SPFriendDBManger shareInstance] deleteFriend:self.model.userId];
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



#pragma mark - click
- (void)gohome {

}


@end
