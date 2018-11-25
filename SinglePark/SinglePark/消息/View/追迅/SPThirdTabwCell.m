//
//  SPThirdTabwCell.m
//  SinglePark
//
//  Created by 斌斌戴 on 2018/11/16.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPThirdTabwCell.h"

@interface SPThirdTabwCell()
@property (nonatomic,strong)UIView *timeView;
@property (nonatomic,strong)UILabel *timeLab;

@property (nonatomic,strong)UIControl *backCont;
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UILabel *nickeLab;
@property (nonatomic,strong)UIImageView *seximg;
@property (nonatomic,strong)UILabel *promptLab;

@end
@implementation SPThirdTabwCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = PTBackColor;

        [self setView];
        
    }
    return self;
}

- (void)setView{
    [self.contentView addSubview:self.timeView];
    [self.timeView addSubview:self.timeLab];
    [self.contentView addSubview:self.backCont];
    [self.backCont addSubview:self.headBtn];
    [self.backCont addSubview:self.nickeLab];
    
    
    [self.backCont addSubview:self.seximg];
    [self.backCont addSubview:self.promptLab];
    
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.width.mas_equalTo(120);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(25);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView).offset(2);
        make.centerX.equalTo(self.timeView);
        make.height.mas_equalTo(20);
    }];
    
    [self.backCont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(10);
        make.right.bottom.equalTo(self.contentView).offset(-20);
        //        make.bottom.equalTo(self.textLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backCont).offset(10);
        make.left.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(50);
        make.bottom.equalTo(self.backCont.mas_bottom).offset(-10);
    }];
    
    [self.nickeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.headBtn).offset(5);
        make.left.equalTo(self.headBtn.mas_right).offset(10);
    }];
    
    [self.seximg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickeLab);
        make.left.equalTo(self.nickeLab.mas_right).offset(2);
        //        make.width.height.mas_equalTo(50);
    }];
    
    [self.promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickeLab);
        make.right.equalTo(self.backCont.mas_right).offset(-10);
    }];
    
    
    [self.timeView.layer setCornerRadius:5];
    [self.backCont.layer setCornerRadius:5];
    self.timeView.clipsToBounds = YES;
    self.backCont.clipsToBounds = YES;
    //    [self.headBtn.layer setCornerRadius:25];
    //    self.headBtn.clipsToBounds = YES;
    
}

- (void)setNewsmodel:(SPMessageModel *)newsmodel{
    if(_newsmodel != newsmodel){
        _newsmodel   = newsmodel;

        self.timeLab.text = _newsmodel.time;
        self.nickeLab.text = @"昵称";
        [self.headBtn setImage:[UIImage imageNamed:_newsmodel.coverimg] forState:UIControlStateNormal];
        [self.seximg setImage:[UIImage imageNamed:@"nv"]];
        self.promptLab.text = _newsmodel.messsage;
        
        [self.headBtn setCornerRadius];
    }
}


- (UIView *)timeView{
    if (_timeView == nil) {
        _timeView = [[UIView alloc] init];
        _timeView.backgroundColor = HexCOLOR(0xD4D4D4);
    }
    return _timeView;
    
}

- (UILabel *)timeLab{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc ] init];
        _timeLab.font = FONT(12);
        _timeLab.textColor =[UIColor whiteColor];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        //        _timeLab.backgroundColor = HexCOLOR(0xD4D4D4);
    }
    return _timeLab;
    
}

- (UIView *)backCont{
    if (_backCont == nil) {
        _backCont = [[UIControl  alloc] init];
        _backCont.backgroundColor = [UIColor whiteColor];
    }
    return _backCont;
    
}
- (UIButton *)headBtn{
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        WEAKSELF
        //        STRONGSELF
        //        [_headBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //
        //
        //        }];
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

- (UIImageView *)seximg{
    if (_seximg == nil) {
        _seximg = [[UIImageView alloc] init];
    }
    return _seximg;
}

- (UILabel *)promptLab{
    if (_promptLab == nil) {
        _promptLab = [[UILabel alloc ] init];
        _promptLab.font = FONT(15);
        _promptLab.textColor = SecondWordColor;
        _promptLab.backgroundColor = [UIColor whiteColor];
        _promptLab.numberOfLines = 2;
    }
    return _promptLab;
    
}



@end
