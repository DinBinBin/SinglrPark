//
//  TranslucentView.m
//  testPlayer
//
//  Created by 斌斌戴 on 2018/9/12.
//  Copyright © 2018年 驿路梨花. All rights reserved.
//

#import "TranslucentView.h"
#import "Masonry.h"

@implementation TranslucentView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.headBtn];
    [self addSubview:self.goodBtn];
    [self addSubview:self.commentBtn];
    [self addSubview:self.titleBtn];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(40);
    }];
    [self.goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.headBtn.mas_bottom).offset(20);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodBtn.mas_bottom).offset(25);
        make.width.height.mas_equalTo(40);
        make.centerX.equalTo(self);

    }];
    
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentBtn.mas_bottom).offset(20);
        make.width.height.mas_equalTo(40);
        make.centerX.equalTo(self);

    }];
    
    self.headBtn.layer.cornerRadius = 20;
    self.headBtn.clipsToBounds = YES;
}

- (UIButton *)headBtn{
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headBtn.tag = 1;
        [_headBtn setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
        [_headBtn addTarget:self action:@selector(clickVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headBtn;
}

- (UIButton *)goodBtn{
    if (_goodBtn == nil) {
        _goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goodBtn.tag  = 2;
        [_goodBtn setImage:[UIImage imageNamed:@"emptylike"] forState:UIControlStateNormal];
        [_goodBtn setImage:[UIImage imageNamed:@"surelike"] forState:UIControlStateSelected];
        [_goodBtn addTarget:self action:@selector(clickVideoBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _goodBtn;
}


- (UIButton *)commentBtn{
    if (_commentBtn == nil) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.tag = 3;
        [_commentBtn setImage:[UIImage imageNamed:@"commentVideo"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(clickVideoBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _commentBtn;
}


- (UIButton *)titleBtn{
    if (_titleBtn == nil) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.tag = 4;
        [_titleBtn setImage:[UIImage imageNamed:@"Report"] forState:UIControlStateNormal];
        [_titleBtn addTarget:self action:@selector(clickVideoBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _titleBtn;
}

- (void)setModel:(SPVideoModel *)model{
    if (_model != model) {
        _model = model;
        [self.goodBtn setTitle:_model.up_nums forState:UIControlStateNormal];
        [self.commentBtn setTitle:_model.comments forState:UIControlStateNormal];

        //设置图片和文字的间距，这里可自行调整
        CGFloat margin = 4;
        self.goodBtn.selected = _model.up;
        self.goodBtn.imageEdgeInsets = UIEdgeInsetsMake(-self.goodBtn.titleLabel.height-margin, 5, 0, 0);
        self.goodBtn.titleEdgeInsets = UIEdgeInsetsMake(self.goodBtn.imageView.height+margin, -self.goodBtn.imageView.width/2-5-self.goodBtn.titleLabel.width/2, 0, 0);
    
        self.commentBtn.imageEdgeInsets = UIEdgeInsetsMake(-self.commentBtn.titleLabel.height-margin, 5, 0, 0);
        self.commentBtn.titleEdgeInsets = UIEdgeInsetsMake(self.commentBtn.imageView.height+margin, -self.commentBtn.imageView.width/2-5-self.commentBtn.titleLabel.width/2, 0, 0);
        
//        设置头像
        [self.headBtn sd_setImageWithURL:[NSURL URLWithString:self.permodel.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"]];
        [self.headBtn setCornerRadius];


    }
}


- (void)clickVideoBtn:(UIButton *)btn{
    if (self.TranslucentBlock) {
        self.TranslucentBlock(btn.tag);
    }
}


@end
