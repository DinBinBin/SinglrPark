//
//  JDWForceRefreshView.m
//  JDWin_B
//
//  Created by 斌斌戴 on 2018/9/30.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import "JDWForceRefreshView.h"
#import "SPCommentTabView.h"
#import "InputToolbar.h"

@interface JDWForceRefreshView()
@property (nonatomic,strong)UIView *whiteView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)SPCommentTabView *commentTabView;
@property (nonatomic,strong)UIButton *sureBtn;

@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)InputToolbar *inputToolbar;
@property (nonatomic,assign)CGFloat inputToolbarY;
@property (nonatomic,strong)SPMessageModel *answerModel;

@end

@implementation JDWForceRefreshView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        SPMessageModel *model = [SPMessageModel modelWithJSON:@{@"head":@"4",
//                                                                @"nickName":@"c昵称",
//                                                                @"messsage":@"我评论了一条信息",
//                                                                @"time":@"12：12",
//                                                                @"gooder":@"34"
//                                                                }];
//
//
//        self.dataArr = [NSMutableArray array];
//        [self.dataArr addObject:model];
//        [self.dataArr addObject:model];
//        [self.dataArr addObject:model];
//        [self.dataArr addObject:model];
//        [self.dataArr addObject:model];
        [self setUI];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.titleLab];
    [self.whiteView addSubview:self.commentTabView];
    [self.whiteView addSubview:self.sureBtn];
    [self addSubview:self.inputToolbar];


    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-KsafeTabIPhonex);
        make.width.left.equalTo(self);
        make.top.equalTo(self).offset(200+kNavigationHeight);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.whiteView);
        make.top.equalTo(self.whiteView).offset(5);
        make.height.mas_equalTo(25);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab);
        make.right.equalTo(self.whiteView.mas_right).offset(-20);
    }];
    
    [self.commentTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.whiteView);
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.whiteView.mas_bottom).offset(-54);
    }];
    
    [self.inputToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTabView.mas_bottom);
        make.width.equalTo(self);
        make.height.mas_equalTo(53);

    }];
    
        
    [self.whiteView setCornerRadius:8];
    
    self.commentTabView.dataArr = self.dataArr;
}

- (UIView *)whiteView{
    if (_whiteView == nil) {
        _whiteView = [[UIView alloc ] init];
        _whiteView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    }
    return _whiteView;
}
- (UILabel *)titleLab{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = Font14;
        _titleLab.text = @"0条评论";
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setImage:[UIImage imageNamed:@"deleteSP"] forState:UIControlStateNormal];

        _sureBtn.titleLabel.font = FONT(15);
        WEAKSELF
        STRONGSELF
        [_sureBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (strongSelf.ClicKSure) {
                strongSelf.ClicKSure();
            }
        }];
    }
    return _sureBtn;
    
}

- (SPCommentTabView *)commentTabView{
    if (_commentTabView == nil) {
        _commentTabView = [[SPCommentTabView alloc ] init];
        WEAKSELF
        STRONGSELF
        _commentTabView.AnswerComment = ^(SPMessageModel * _Nonnull model) {
            if ([strongSelf.infoModel.user_id floatValue] == [DBAccountInfo sharedInstance].model.userId) {
                strongSelf.answerModel = model;
                strongSelf.inputToolbar.textInput.text = @"回复";
            }else{
                [MBProgressHUD showMessage:@"只能视频作者回复"];
                
            }
        };
    }
    return _commentTabView;
}


- (InputToolbar *)inputToolbar{
    if (_inputToolbar == nil) {
        _inputToolbar = [InputToolbar shareInstance];
        _inputToolbar.width = kScreenWidth;
        _inputToolbar.height = 53;
        _inputToolbar.textViewMaxVisibleLine = 4;
        [_inputToolbar resetInputToolbar];
        WEAKSELF
        STRONGSELF
        _inputToolbar.sendContent = ^(NSObject *content) {  //发送文字
            if (strongSelf.answerModel) {
                [strongSelf answer:(NSString *)content];
            }else{
                [strongSelf comment:(NSString *)content];
            }
            
        };
        _inputToolbar.inputToolbarFrameChange = ^(CGFloat height, CGFloat orignY) {
            [strongSelf.inputToolbar mas_remakeConstraints:^(MASConstraintMaker *make) {
                NSLog(@"%f  ==%f",orignY,height);
                make.bottom.equalTo(strongSelf.mas_bottom).offset(-orignY);
                make.width.equalTo(strongSelf);
                make.height.mas_equalTo(height);
            }];
        };
        
    }
    return _inputToolbar;
}


// 评论回复
- (void)answer:(NSString *)str{
    NSDictionary *params =  @{@"comment_id":self.answerModel.messageId,
                              @"content":str,
                              };
    [JDWNetworkHelper POST:SPAnswer parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [self comments];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
        //        [self.listTabView.mj_header endRefreshing ];
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        //        [self.listTabView.mj_header endRefreshing ];
        
    }];
    
}

//直接评论
- (void)comment:(NSString *)str{
    NSDictionary *params =  @{@"video_id":self.infoModel.videoId,
                              @"content":str,
                              };
    [JDWNetworkHelper POST:SPCommentscreate parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [self comments];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        self.inputToolbar.isBecomeFirstResponder = NO;
        [self.inputToolbar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentTabView.mas_bottom);
            make.width.equalTo(self);
            make.height.mas_equalTo(53);
        }];
  
}


- (void)setInfoModel:(SPCoverModel *)infoModel{
    if (_infoModel != infoModel) {
        _infoModel = infoModel;
        [self comments];
        
    }
}

// 获取评论列表
- (void)comments{
    NSDictionary *params = @{@"video_id":self.infoModel.videoId,
                             };
    [JDWNetworkHelper POST:SPComments parameters:params success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            self.dataArr = [[SPMessageModel modelArrayWithJSON:responseDic[@"data"][@"items"]] mutableCopy];
            self.commentTabView.dataArr = self.dataArr;
            self.titleLab.text = [NSString stringWithFormat:@"%ld条评论",self.dataArr.count];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
    }];
    
    
}


@end
