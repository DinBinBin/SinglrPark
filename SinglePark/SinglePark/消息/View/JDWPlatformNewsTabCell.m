//
//  JDWPlatformNewsTabCell.m
//  JDWin_B
//
//  Created by 斌斌戴 on 2018/7/12.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import "JDWPlatformNewsTabCell.h"

@interface JDWPlatformNewsTabCell()
@property (nonatomic,strong)UIView *timeView;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UIView *textView;
@property (nonatomic,strong)UILabel *textLab;


@end

@implementation JDWPlatformNewsTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setView];
        
    }
    return self;
}

- (void)setView{
    [self.contentView addSubview:self.timeView];
    [self.timeView addSubview:self.timeLab];
    [self.contentView addSubview:self.textView];
    [self.textView addSubview:self.textLab];

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

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(10);
        make.right.bottom.equalTo(self.contentView).offset(-20);
//        make.bottom.equalTo(self.textLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom);

    }];
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(10);
        make.left.equalTo(self.textView).offset(10);
        make.right.equalTo(self.textView.mas_right).offset(10);
        make.bottom.equalTo(self.textView.mas_bottom).offset(-10);
    }];
    
    
    [self.timeView.layer setCornerRadius:5];
    [self.textView.layer setCornerRadius:5];
    self.timeView.clipsToBounds = YES;
    self.textView.clipsToBounds = YES;

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
        self.textLab.text = _newsmodel.messsage;
        
        
        
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

- (UIView *)textView{
    if (_textView == nil) {
        _textView = [[UIView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
    
}

- (UILabel *)textLab{
    if (_textLab == nil) {
        _textLab = [[UILabel alloc ] init];
        _textLab.font = FONT(15);
        _textLab.textColor = SecondWordColor;
        _textLab.backgroundColor = [UIColor whiteColor];
        _textLab.numberOfLines = 0;
    }
    return _textLab;
    
}
@end
