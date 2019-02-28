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
    [self.contentView addSubview:self.coverImg];
    [self.coverImg addSubview:self.titleLab];
//    [self.backView addSubview:self.coverImg];
    [self.coverImg addSubview:self.promptImg];
    
    
//    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(10);
//        make.right.equalTo(self.contentView.mas_right).offset(-10);
//        make.top.equalTo(self.contentView);
//        make.height.mas_equalTo(kScreenWidth-20);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//    }];
    

        
    [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(self.coverImg.mas_width);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.coverImg).offset(5);
    }];
    
        [self.promptImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.coverImg);
        }];
    
    [self.coverImg.layer setCornerRadius:8];
    self.coverImg.clipsToBounds = YES;

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
        _titleLab.text = @"关于我&关于她";
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
        _coverImg.image = ImageNamed(@"默认未上传视频");
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

- (void)setCoverModel:(SPCoverModel *)coverModel {
        _coverModel = coverModel;
        if (([_coverModel.thumb isEqualToString:@""] || _coverModel.thumb) && nil && _coverModel) {
            if (_coverModel.thumb_id) {
                [self requestThumb:_coverModel.thumb_id];
            }
        }else{
            [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[_coverModel.thumb stringByAppendingString:videoCover]]  placeholderImage:ImageNamed(@"视频加载失败")];

        }
        
}

- (void)requestThumb:(NSString *)thumdId {
    
    WEAKSELF
    STRONGSELF
    [JDWNetworkHelper POST:SPQiuniiuCat parameters:@{@"thumb_id":thumdId} success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *arr = responseDic[@"data"][@"items"];
            if (arr.count > 0) {
                NSString *imgUrl = SPURL_API_Img(responseDic[@"data"][@"items"][0][@"key"]);
                [strongSelf.coverImg sd_setImageWithURL:[NSURL URLWithString:[imgUrl stringByAppendingString:videoCover]]   placeholderImage:ImageNamed(@"视频加载失败")];
            }
          
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}



@end
