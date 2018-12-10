//
//  SPCardTabCell.m
//  SinglePark
//
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCardTabCell.h"
#import "SPPersonalController.h"
#import "SPPursuitView.h"
@interface SPCardTabCell()


@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UILabel *nickeLab;
@property (nonatomic,strong)UIImageView *sexImg;
@property (nonatomic,strong)UILabel *occupation;
@property (nonatomic,strong)UILabel *didian;
@property (nonatomic,strong)UILabel *singer;
@property (nonatomic,strong)SPPursuitView *pursuitView;


@end
@implementation SPCardTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.headBtn];
    [self.backView addSubview:self.nickeLab];
    [self.backView addSubview:self.sexImg];
    [self.backView addSubview:self.occupation];
    [self.backView addSubview:self.didian];
    [self.backView addSubview:self.singer];
    [self.backView addSubview:self.pursuitView];

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.nickeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBtn).offset(5);
        make.left.equalTo(self.headBtn.mas_right).offset(10);
    }];
    
    [self.sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickeLab);
        make.left.equalTo(self.nickeLab.mas_right).offset(10);
    }];
    
    [self.occupation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickeLab);
        make.bottom.equalTo(self.headBtn.mas_bottom).offset(-5);
    }];
    
    [self.didian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.bottom.equalTo(self.occupation.mas_bottom);
    }];
    
    [self.singer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBtn.mas_bottom).offset(10);
        make.left.equalTo(self.headBtn);
        make.right.equalTo(self.backView.mas_right).offset(-10);
    }];
    
    [self.pursuitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.singer.mas_bottom);
        make.width.equalTo(self.backView);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.backView.mas_bottom);
    }];
    [self.backView.layer setCornerRadius:8];
    self.backView.clipsToBounds = YES;
}


// 懒加载
- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];

    }
    return _backView;
}

- (UIButton *)headBtn{
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        WEAKSELF
        STRONGSELF
        [_headBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            SPPersonalController *card = [[SPPersonalController  alloc] init];
            [[strongSelf viewController].navigationController pushViewController:card animated:YES];
        }];
    }
    return _headBtn;
}

- (UILabel *)nickeLab{
    if (_nickeLab == nil) {
        _nickeLab = [[UILabel alloc] init];
        _nickeLab.text = @"昵称";
        _nickeLab.font = FONT(16);
        _nickeLab.textColor = FirstWordColor;
    }
    return _nickeLab;
}

- (UIImageView *)sexImg{
    if (_sexImg == nil) {
        _sexImg = [[UIImageView alloc] init];
    }
    return _sexImg;
}

- (UILabel *)occupation{
    if (_occupation == nil) {
        _occupation = [[UILabel alloc] init];
        _occupation.text = @"工程师";
        _occupation.font = FONT(14);
        _occupation.textColor = SecondWordColor;
    }
    return _occupation;
}

- (UILabel *)didian{
    if (_didian == nil) {
        _didian = [[UILabel alloc] init];
        _didian.text = @"广东深圳";
        _didian.font = FONT(14);
        _didian.textColor = SecondWordColor;
    }
    return _didian;
}

- (UILabel *)singer{
    if (_singer == nil) {
        _singer = [[UILabel alloc] init];
        _singer.text = @"昵称";
        _singer.font = FONT(14);
        _singer.textColor = FirstWordColor;
        _singer.numberOfLines = 2;
    }
    return _singer;
}

- (SPPursuitView *)pursuitView{
    if (_pursuitView == nil) {
        _pursuitView = [[SPPursuitView alloc] init];
    }
    return _pursuitView;
}



- (void)setModel:(SPPersonModel *)model{
    if (_model != model) {
        _model = model;
        [self.headBtn setImage:[UIImage imageNamed:_model.avatar] forState:UIControlStateNormal];
        [self.headBtn.layer setCornerRadius:30];
        self.headBtn.clipsToBounds = YES;

        self.nickeLab.text = _model.nickName;
        self.sexImg.image = [UIImage imageNamed:_model.sex];
        self.occupation.text = _model.occupation;
        self.didian.text = _model.didian;
        self.singer.text = _model.singer?_model.singer:nil;
        self.pursuitView.number = _model.number;
    }
}


@end
