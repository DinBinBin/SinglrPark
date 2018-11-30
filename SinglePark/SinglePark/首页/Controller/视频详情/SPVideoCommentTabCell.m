//
//  SPVideoCommentTabCell.m
//  SinglePark
//
//  Created by 斌斌戴 on 2018/11/16.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPVideoCommentTabCell.h"

@interface SPVideoCommentTabCell()
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UIButton *goodBtn;
@property (nonatomic,strong)UILabel *textLab;

@end
@implementation SPVideoCommentTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.headBtn];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.goodBtn];
    [self.contentView addSubview:self.textLab];

    
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.headBtn);
        make.left.equalTo(self.headBtn.mas_right).offset(20);
    }];
    
    [self.goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLab);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom);
        make.left.equalTo(self.nameLab);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    
    [self.headBtn.layer setCornerRadius:20];
    self.headBtn.clipsToBounds = YES;
}



- (UIButton *)headBtn{
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];

//        WEAKSELF
//        STRONGSELF
//
//        [_headBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//
//
//        }];
    }
    return _headBtn;
}

- (UILabel *)nameLab{
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.text = @"昵称";
        _nameLab.font = FONT(16);
        _nameLab.textColor = [UIColor whiteColor];
    }
    return _nameLab;
}
- (UIButton *)goodBtn{
    if (_goodBtn == nil) {
        _goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goodBtn.titleLabel.font = Font14;
        [_goodBtn setImage:[UIImage imageNamed:@"emptylike"] forState:UIControlStateNormal];
        [_goodBtn setImage:[UIImage imageNamed:@"surelike"] forState:UIControlStateSelected];

//        WEAKSELF
//        STRONGSELF
//        [_goodBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//
//
//        }];
    }
    return _goodBtn;
}

- (UILabel *)textLab{
    if (_textLab == nil) {
        _textLab = [[UILabel alloc] init];
        _textLab.text = @"昵称";
        _textLab.font = FONT(16);
        _textLab.textColor = [UIColor whiteColor];
        _textLab.numberOfLines = 0;
    }
    return _textLab;
}



- (void)setModel:(SPMessageModel *)model{
    if (_model != model) {
        _model = model;
        self.nameLab.text = _model.nickName;
//        [self.titleLab.layer setCornerRadius:6];
//        self.titleLab.clipsToBounds = YES;
        [self.headBtn setImage:[UIImage imageNamed:_model.head] forState:UIControlStateNormal];
        self.textLab.text = _model.messsage;
        [self.goodBtn setTitle:_model.gooder forState:UIControlStateNormal];

//        self.sexImg.image = [UIImage imageNamed:_model.sex];
//        self.coverImg.image = [UIImage imageNamed:_model.videoCover];
    }
}

@end
    
