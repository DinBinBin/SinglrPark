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


@end

@implementation JDWForceRefreshView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
        make.height.mas_equalTo(200);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.whiteView);
        make.top.equalTo(self.whiteView).offset(5);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLab.mas_bottom);
        make.right.equalTo(self.whiteView.mas_right).offset(-20);
    }];
    
    [self.commentTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self.whiteView);
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.whiteView.mas_bottom);
    }];
        
    [self.whiteView setCornerRadius:8];
}

- (UIView *)whiteView{
    if (_whiteView == nil) {
        _whiteView = [[UIView alloc ] init];
        _whiteView.backgroundColor = PTBackColor;
    }
    return _whiteView;
}
- (UILabel *)titleLab{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT(12);
        _titleLab.text = @"344条评论";
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"删除" forState:UIControlStateNormal];
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
    }
    return _commentTabView;
}


@end
