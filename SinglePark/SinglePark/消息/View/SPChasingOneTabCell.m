//
//  SPChasingOneTabCell.m
//  SinglePark
//
//  Created by DBB on 2018/10/25.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPChasingOneTabCell.h"
@interface SPChasingOneTabCell()
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIButton *headBtn;
@property (nonatomic,strong)UILabel *nickeLab;
@property (nonatomic,strong)UIImageView *sexImg;
@property (nonatomic,strong)UILabel *promptLab;
@property (nonatomic,strong)UILabel *voiceLab;
@property (nonatomic,strong)UIButton *voiceBtn;
//@property (nonatomic,strong)UIButton *voiceBtn;
//@property (nonatomic,strong)UIButton *voiceBtn;

@end

@implementation SPChasingOneTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
