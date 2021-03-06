//
//  SPMineHeadTabCell.m
//  SinglePark
//
//  Created by DBB on 2018/10/14.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPMineHeadTabCell.h"


@interface SPMineHeadTabCell()

@property (nonatomic,strong)UIImageView *headimg;
@property (nonatomic,strong)UILabel *nickeLab;
@property (nonatomic,strong)UIImageView *sexImg;
@property (nonatomic,strong)UILabel *occupation;
@end
@implementation SPMineHeadTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.headimg];
    [self.contentView addSubview:self.nickeLab];
    [self.contentView addSubview:self.sexImg];
    [self.contentView addSubview:self.occupation];
    
    
    
    [self.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(70);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    [self.nickeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headimg).offset(5);
        make.left.equalTo(self.headimg.mas_right).offset(10);
    }];
    
    [self.sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickeLab);
        make.left.equalTo(self.nickeLab.mas_right).offset(10);
    }];
    
    [self.occupation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickeLab);
        make.top.equalTo(self.nickeLab.mas_bottom).offset(10);
    }];
    
    
}


// 懒加载


- (UIImageView *)headimg{
    if (_headimg == nil) {
        _headimg = [[UIImageView alloc] init];
        
    }
    return _headimg;
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
        _occupation.font = FONT(14);
        _occupation.textColor = SecondWordColor;
    }
    return _occupation;
}



- (void)setModel:(SPPersonModel *)model{
    if (_model != model) {
        _model = model;
        [self.headimg sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:ImageNamed(@"logo") options:SDWebImageRefreshCached];
        self.nickeLab.text = _model.nickName;
        self.sexImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",_model.sex]];
        self.occupation.text = _model.job.firstObject;
        [self.headimg.layer setCornerRadius:35];
        self.headimg.clipsToBounds = YES;

    }else{
        self.headimg.image = ImageNamed(@"logo");
    }
}

@end
