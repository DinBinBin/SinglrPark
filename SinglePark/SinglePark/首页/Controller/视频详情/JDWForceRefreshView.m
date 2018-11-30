//
//  JDWForceRefreshView.m
//  JDWin_B
//
//  Created by 斌斌戴 on 2018/9/30.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import "JDWForceRefreshView.h"
#import "SPCommentTabView.h"

@interface JDWForceRefreshView()
@property (nonatomic,strong)UIView *whiteView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)SPCommentTabView *commentTabView;
@property (nonatomic,strong)UIButton *sureBtn;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation JDWForceRefreshView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        SPMessageModel *model = [[SPMessageModel alloc] initWithDataDic:@{@"head":@"4",
                                                                          @"nickName":@"c昵称",
                                                                          @"messsage":@"我评论了一条信息",
                                                                          @"time":@"12：12",
                                                                          @"gooder":@"34"
                                                                          }];
        
        
        self.dataArr = [NSMutableArray array];
        [self.dataArr addObject:model];
        [self.dataArr addObject:model];
        [self.dataArr addObject:model];
        [self.dataArr addObject:model];
        [self.dataArr addObject:model];
        [self setUI];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.titleLab];
    [self.whiteView addSubview:self.commentTabView];
    [self.whiteView addSubview:self.sureBtn];

    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.width.left.equalTo(self);
        make.top.equalTo(self).offset(200+kNavigationHeight+KAddIPhonex);
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
        make.bottom.equalTo(self.whiteView.mas_bottom);
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
        _titleLab.text = @"344条评论";
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"X" forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [UIColor redColor];
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
        _commentTabView.AnswerComment = ^(SPMessageModel * _Nonnull model) {
            
            
        };
    }
    return _commentTabView;
}

- (void)answer{
    
    
}

- (void)comment{
    
    
}


@end
