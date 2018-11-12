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
        make.top.equalTo(self.goodBtn.mas_bottom).offset(20);
        make.width.height.mas_equalTo(40);
        make.centerX.equalTo(self);

    }];
    
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentBtn.mas_bottom).offset(20);
        make.width.height.mas_equalTo(40);
        make.centerX.equalTo(self);

    }];
    
}

- (UIButton *)headBtn{
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_headBtn setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    }
    return _headBtn;
}

- (UIButton *)goodBtn{
    if (_goodBtn == nil) {
        _goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goodBtn setImage:[UIImage imageNamed:@"chase"] forState:UIControlStateNormal];
    }
    return _goodBtn;
}


- (UIButton *)commentBtn{
    if (_commentBtn == nil) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];

    }
    return _commentBtn;
}


- (UIButton *)titleBtn{
    if (_titleBtn == nil) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];

    }
    return _titleBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
