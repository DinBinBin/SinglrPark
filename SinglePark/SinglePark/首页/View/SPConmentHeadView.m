//
//  SPConmentHeadView.m
//  SinglePark
//
//  Created by 斌斌戴 on 2019/1/3.
//  Copyright © 2019年 DBB. All rights reserved.
//

#import "SPConmentHeadView.h"

@interface SPConmentHeadView()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UIButton *goodBtn;
@property (nonatomic,strong)UILabel *textLab;

@end
@implementation SPConmentHeadView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
//        self.contentView.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor blackColor];
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
    
    self.goodBtn.frame = CGRectMake(kScreenWidth-42, 10, 22, 22);
    
//    [self.goodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.nameLab);
//        make.right.equalTo(self.contentView.mas_right).offset(-20);
//    }];
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom);
        make.left.equalTo(self.nameLab);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
    [self.headBtn.layer setCornerRadius:20];
    self.headBtn.clipsToBounds = YES;
    
    
    //单击的手势
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tapRecognize.numberOfTapsRequired = 1;
    tapRecognize.delegate = self;
    [tapRecognize setEnabled :YES];
    [tapRecognize delaysTouchesBegan];
    [tapRecognize cancelsTouchesInView];
    [self.contentView addGestureRecognizer:tapRecognize];
}



- (UIButton *)headBtn{
    if (_headBtn == nil) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];

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
        [_goodBtn setImage:[UIImage imageNamed:@"点赞空心"] forState:UIControlStateNormal];
        [_goodBtn setImage:[UIImage imageNamed:@"点赞实心"] forState:UIControlStateSelected];
        
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
//        self.nameLab.text = @"2342423";
        //        [self.titleLab.layer setCornerRadius:6];
        //        self.titleLab.clipsToBounds = YES;
//        [self.headBtn setImage:[UIImage imageNamed:_model.head] forState:UIControlStateNormal];
        self.textLab.text = _model.content;
//        [self.goodBtn setTitle:[NSString stringWithFormat:@"  %@",_model.gooder] forState:UIControlStateNormal];
        
        //        self.sexImg.image = [UIImage imageNamed:_model.sex];
        //        self.coverImg.image = [UIImage imageNamed:_model.videoCover];
    }
}

-(void) handleTap:(UITapGestureRecognizer *)recognizer{
    if (self.HeadBlock) {

        self.HeadBlock();
    }
    
}
@end
