//
//  SPCommentTablCell.m
//  SinglePark
//
//  Created by DBB on 2018/10/21.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCommentTablCell.h"
#import "SPBusinessCardController.h"

@interface SPCommentTablCell()
@property (nonatomic,strong)UIView *timeView;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UIControl *backCont;
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UILabel *nickeLab;
@property (nonatomic,strong)UILabel *textLab;
@property (nonatomic,strong)UIImageView *coverImg;


@end

@implementation SPCommentTablCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    [self.backCont addSubview:self.textLab];
    [self.backCont addSubview:self.coverImg];

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
        make.width.height.mas_equalTo(55);
        make.bottom.equalTo(self.backCont.mas_bottom).offset(-10);

    }];
    
    [self.nickeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.headBtn).offset(2);
        make.left.equalTo(self.headBtn.mas_right).offset(10);
    }];

    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickeLab.mas_bottom).offset(8);
        make.left.equalTo(self.nickeLab);
        make.right.equalTo(self.backCont.mas_right).offset(-60);
    }];
    
    [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.headBtn);
        make.width.mas_equalTo(40);
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
        
        
        
        // iOS 生成的时间戳是10位
        //        NSTimeInterval interval    =[_newsmodel.publishTime doubleValue] / 1000.0;
        //        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        //
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //        NSString *dateString       = [formatter stringFromDate: date];
        self.timeLab.text = _newsmodel.time;
        self.nickeLab.text = @"昵称";
        self.textLab.text = _newsmodel.messsage;
        [self.headBtn setImage:[UIImage imageNamed:_newsmodel.coverimg] forState:UIControlStateNormal];
        [self.coverImg setImage:[UIImage imageNamed:_newsmodel.coverimg]];
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
        _timeLab.font = FONT(14);
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
        WEAKSELF
        STRONGSELF
        [_headBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            SPBusinessCardController *card = [[SPBusinessCardController  alloc] init];
//            card.model = strongSelf.newsmodel;
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

- (UILabel *)textLab{
    if (_textLab == nil) {
        _textLab = [[UILabel alloc ] init];
        _textLab.font = FONT(14);
        _textLab.textColor = SecondWordColor;
        _textLab.backgroundColor = [UIColor whiteColor];
        _textLab.numberOfLines = 2;
    }
    return _textLab;
    
}
- (UIImageView *)coverImg{
    if (_coverImg == nil) {
        _coverImg = [[UIImageView alloc] init];
    }
    return _coverImg;
}


@end
