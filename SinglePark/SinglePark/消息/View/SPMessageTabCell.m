//
//  SPMessageTabCell.m
//  SinglePark
//
//  Created by DBB on 2018/10/5.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPMessageTabCell.h"
@interface SPMessageTabCell()
@property (nonatomic,strong)UIImageView *promptImg;
@property (nonatomic,strong)UILabel *numberLab;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *messageLab;
@property (nonatomic,strong)UILabel *timeLab;

@end
@implementation SPMessageTabCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.promptImg];
    [self.contentView addSubview:self.numberLab];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.messageLab];
    [self.contentView addSubview:self.timeLab];
    
    [self.promptImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.width.height.mas_equalTo(60);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);

    }];
    
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptImg).offset(-5);
        make.left.equalTo(self.promptImg.mas_right).offset(-8);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptImg).offset(5);
        make.left.equalTo(self.promptImg.mas_right).offset(20);
    }];
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.promptImg.mas_bottom).offset(-10);
        make.left.equalTo(self.titleLab);

    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [self.numberLab setCornerRadius];
}



- (UIImageView *)promptImg{
    if (_promptImg == nil) {
        _promptImg = [[UIImageView alloc] init];
        _promptImg.image = [UIImage imageNamed:@""];
    }
    return _promptImg;
}

- (UILabel *)numberLab{
    if (_numberLab == nil) {
        _numberLab = [[UILabel alloc] init];
        _numberLab.text = @"10";
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.font = FONT(8);
        _numberLab.textColor = [UIColor whiteColor];
        _numberLab.backgroundColor = [UIColor redColor];
    }
    return _numberLab;
}

- (UILabel *)titleLab{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"0公里";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = FONT(16);
        _titleLab.textColor = FirstWordColor;
    }
    return _titleLab;
}

- (UILabel *)messageLab{
    if (_messageLab == nil) {
        _messageLab = [[UILabel alloc] init];
        _messageLab.text = @"昵称";
        _messageLab.font = FONT(15);
        _messageLab.textColor = SecondWordColor;
    }
    return _messageLab;
}
- (UILabel *)timeLab{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.text = @"12:00";
        _timeLab.font = FONT(14);
        _timeLab.textColor = SecondWordColor;
        _timeLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeLab;
}

- (void)setModel:(SPMessageModel *)model{
    if (_model != model) {
        _model = model;
        self.promptImg.image = [UIImage imageNamed:_model.head];
        self.titleLab.text = _model.nickName;
        self.messageLab.text = _model.messsage;
        self.timeLab.text = _model.time;
        if (_model.unreadCount == 0) {
            self.numberLab.hidden = YES;
        }else{
            self.numberLab.hidden = NO;
            self.numberLab.text = [NSString stringWithFormat:@"%d",_model.unreadCount];
        }
    }
}



@end
