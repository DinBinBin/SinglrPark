//
//  SPPursuitView.m
//  SinglePark
//
//  Created by DBB on 2018/10/6.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPPursuitView.h"

@interface SPPursuitView()
@property (nonatomic,strong)UILabel *myHunterLab;

@end

@implementation SPPursuitView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.myHunterLab];
    [self.myHunterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
}


- (UILabel *)myHunterLab{
    if (_myHunterLab == nil) {
        _myHunterLab = [[UILabel alloc] init];
        _myHunterLab.textColor = FirstWordColor;
        _myHunterLab.font = FONT(14);
        self.myHunterLab.text = @"我的追求者(暂无)";
    }
    return _myHunterLab;
}

- (void)setNumber:(NSArray *)number{
    if (_number != number && number.count) {
        _number = number;
        self.myHunterLab.text = [NSString stringWithFormat:@"我的追求者(%ld)",number.count];
        for (int i = 0; i<number.count; i++) {
            UIImageView *headimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
            [self addSubview:headimg];
            SPPersonModel *model = number[i];
            
            [headimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.myHunterLab);
                make.left.equalTo(self.myHunterLab.mas_right).offset(20+i*60);
                make.width.height.mas_equalTo(40);
            }];
            [headimg setCornerRadius];
            [headimg sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"logo"]];
        }
    }
    
}

@end
