//
//  SPChasingTwoTabCell.m
//  SinglePark
//
//  Created by DBB on 2018/10/25.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPChasingTwoTabCell.h"

@interface SPChasingTwoTabCell()
@property (nonatomic,strong)UIView *timeView;
@property (nonatomic,strong)UILabel *timeLab;

@property (nonatomic,strong)UIControl *backCont;
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UILabel *nickeLab;
@property (nonatomic,strong)UIImageView *seximg;
@property (nonatomic,strong)UILabel *promptLab;
@property (nonatomic,strong)UILabel *messageLab;
@property (nonatomic,strong)UIButton *messageBtn;

@property (nonatomic,strong)UIButton *acceptBtn;
@property (nonatomic,strong)UIButton *refuseBtn;


@end
@implementation SPChasingTwoTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setView];
        self.backgroundColor = PTBackColor;

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
    [self.backCont addSubview:self.messageLab];
    [self.backCont addSubview:self.messageBtn];
    [self.backCont addSubview:self.acceptBtn];
    [self.backCont addSubview:self.refuseBtn];

    
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
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headBtn);
        make.top.equalTo(self.headBtn.mas_bottom).offset(15);
    }];
    
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageLab);
        make.right.equalTo(self.messageLab.mas_right).offset(5);
    }];
    
    [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLab.mas_bottom).offset(15);
        make.right.equalTo(self.backCont.mas_centerX).offset(-20);
        make.bottom.equalTo(self.backCont.mas_bottom).offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acceptBtn.mas_right).offset(40);
        make.size.centerY.equalTo(self.acceptBtn);
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



        // iOS 生成的时间戳是10位
        //        NSTimeInterval interval    =[_newsmodel.publishTime doubleValue] / 1000.0;
        //        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        //
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //        NSString *dateString       = [formatter stringFromDate: date];
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
        _promptLab.font = FONT(14);
        _promptLab.textColor = SecondWordColor;
        _promptLab.backgroundColor = [UIColor whiteColor];
        _promptLab.numberOfLines = 2;
    }
    return _promptLab;
    
}

- (UILabel *)messageLab{
    if (_messageLab == nil) {
        _messageLab = [[UILabel alloc ] init];
        _messageLab.font = FONT(14);
        _messageLab.textColor = SecondWordColor;
        _messageLab.backgroundColor = [UIColor whiteColor];
        _messageLab.text = @"附加消息：";
    }
    return _messageLab;
    
}

- (UIButton *)messageBtn{
    if (_messageBtn == nil) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        WEAKSELF
        //        STRONGSELF
        //        [_messageBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //
        //
        //        }];
    }
    return _messageBtn;
}

- (UIButton *)acceptBtn{
    if (_acceptBtn == nil) {
        _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _acceptBtn.layer.borderWidth = 1;
        [_acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
        [_acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _acceptBtn.backgroundColor = ThemeColor;
        [_acceptBtn setCornerRadius:3];
        //        WEAKSELF
        //        STRONGSELF
        //        [_acceptBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //
        //
        //        }];
    }
    return _acceptBtn;
}


- (UIButton *)refuseBtn{
    if (_refuseBtn == nil) {
        _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refuseBtn.layer.borderWidth = 1;
        _refuseBtn.layer.borderColor = ThemeColor.CGColor;
        [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
        _refuseBtn.backgroundColor = [UIColor whiteColor];
        [_refuseBtn setCornerRadius:3];
        //        WEAKSELF
        //        STRONGSELF
        //        [_refuseBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        //
        //
        //        }];
    }
    return _refuseBtn;
}
@end
