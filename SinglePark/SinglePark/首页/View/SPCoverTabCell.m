//
//  SPCoverTabCell.m
//  SinglePark
//
//  Created by DBB on 2018/10/4.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCoverTabCell.h"
#import "SPBusinessCardController.h"

@interface SPCoverTabCell()
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UILabel *nickeLab;
@property (nonatomic,strong)UIImageView *sexImg;
@property (nonatomic,strong)UIImageView *coverImg;
@property (nonatomic,strong)UIImageView *promptImg;

@end

@implementation SPCoverTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.nickeLab];
    [self.contentView addSubview:self.sexImg];
    [self.contentView addSubview:self.coverImg];
    [self.contentView addSubview:self.headBtn];
    [self.coverImg addSubview:self.promptImg];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(120);
    }];
    
 
    [self.nickeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.titleLab.mas_bottom).offset(3);
        make.left.mas_equalTo(75);
    }];

    [self.sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickeLab);
        make.left.equalTo(self.nickeLab.mas_right).offset(2);
        make.width.height.mas_equalTo(15);
    }];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickeLab.mas_bottom).offset(3);
        make.left.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headBtn.mas_centerY);
        make.left.equalTo(self.headBtn);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(kScreenWidth-40);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];

    [self.promptImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImg);
    }];
    [self.headBtn.layer setCornerRadius:25];
    self.headBtn.clipsToBounds = YES;
}


- (UILabel *)titleLab{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"0公里";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = FONT(12);
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.backgroundColor = HexCOLOR(0xd7d7d7);
    }
    return _titleLab;
}

- (UIButton *)headBtn{
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        WEAKSELF
        STRONGSELF
        [_headBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            SPBusinessCardController *card = [[SPBusinessCardController  alloc] init];
            card.model = strongSelf.model;
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

- (UIImageView *)coverImg{
    if (_coverImg == nil) {
        _coverImg = [[UIImageView alloc] init];
    }
    return _coverImg;
}

- (UIImageView *)promptImg{
    if (_promptImg == nil) {
        _promptImg = [[UIImageView alloc] init];
        _promptImg.image = [UIImage imageNamed:@""];
    }
    return _promptImg;
}

- (void)setModel:(SPPersonModel *)model{
    if (_model != model) {
        _model = model;
        if (_model.first_video.count > 0) {
            //        self.titleLab.text = _model.first_video.distance;
            [self.titleLab.layer setCornerRadius:6];
            self.titleLab.clipsToBounds = YES;
            [self.headBtn sd_setImageWithURL:[NSURL URLWithString:_model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"]];
            self.nickeLab.text = _model.nickName;
            self.sexImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",_model.sex]];
            
            SPCoverModel *covermodel = [SPCoverModel modelWithDictionary:_model.first_video[0]];
            [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[covermodel.video stringByAppendingString:videoCover]] placeholderImage:[UIImage imageNamed:@""]];
            
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
