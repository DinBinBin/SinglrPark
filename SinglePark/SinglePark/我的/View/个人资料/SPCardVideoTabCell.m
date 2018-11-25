//
//  SPCardVideoTabCell.m
//  SinglePark
//
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPCardVideoTabCell.h"
@interface SPCardVideoTabCell()


@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIImageView *coverImg;
@property (nonatomic,strong)UIImageView *promptImg;



@end
@implementation SPCardVideoTabCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLab];
    [self.backView addSubview:self.coverImg];
    [self.coverImg addSubview:self.promptImg];
    
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(kScreenWidth-20);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backView).offset(5);
    }];
        
    [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.width.equalTo(self.backView);
        make.bottom.equalTo(self.backView.mas_bottom);
    }];
    
        [self.promptImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.coverImg);
        }];
}

// 懒加载
- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.8];
    }
    return _backView;
}
- (UILabel *)titleLab{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"0公里";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = FONT(15);
        _titleLab.textColor = [UIColor whiteColor];
//        _titleLab.backgroundColor = SecondWordColor;
    }
    return _titleLab;
}


- (UIImageView *)coverImg{
    if (_coverImg == nil) {
        _coverImg = [[UIImageView alloc] init];
        _coverImg.image = [UIImage imageNamed:@"4"];
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

@end
