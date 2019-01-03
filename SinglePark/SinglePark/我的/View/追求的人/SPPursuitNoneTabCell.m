//
//  SPPursuitNoneTabCell.m
//  SinglePark
//
//  Created by DBB on 2018/12/9.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPursuitNoneTabCell.h"
@interface SPPursuitNoneTabCell()

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *promptLab;
@property (nonatomic,strong)UIImageView *promptImg;
@end

@implementation SPPursuitNoneTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
        
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.promptLab];
    [self.backView addSubview:self.promptImg];
    
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView).offset(30);
        make.height.mas_equalTo(200);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    [self.promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(20);
        make.centerX.equalTo(self.backView);
//        make.width.mas_equalTo(60);
    }];
    
    [self.promptImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLab.mas_bottom).offset(30);
        make.centerX.equalTo(self.backView);
        make.width.height.mas_equalTo(50);
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


- (UILabel *)promptLab{
    if (_promptLab == nil) {
        _promptLab = [[UILabel alloc] init];
        _promptLab.text = @"你当前还没有追求的人哎\n你可以逛逛公园追求他人嘛\n爱是真诚，爱是勇气^_";
        _promptLab.font = FONT(16);
        _promptLab.textColor = FirstWordColor;
        _promptLab.numberOfLines = 0;
        _promptLab.textAlignment = NSTextAlignmentCenter;
    }
    return _promptLab;
}

- (UIImageView *)promptImg{
    if (_promptImg == nil) {
        _promptImg = [[UIImageView alloc] init];
        _promptImg.image = [UIImage imageNamed:@"icon5_sel"];
    }
    return _promptImg;
}

- (void)setViewType:(SPPursuitViewType)viewType {
    _viewType = viewType;
    if (_viewType == SPMePursuitViewType) {
        _promptLab.text = @"你当前还没有追求的人哎\n你可以逛逛公园追求他人嘛\n爱是真诚，爱是勇气^_";
        
    }else{
        _promptLab.text = @"当前还没有追求的人追你哎\n你可以逛逛公园追求他人嘛\n爱是真诚，爱是勇气^_";
        
    }
}

@end
