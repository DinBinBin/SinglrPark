//
//  SPPursuitVoiceCell.h
//  SinglePark
//
//  Created by chensw on 2019/1/4.
//  Copyright © 2019 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPPursuitVoiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)(OYModel *);
@property (nonatomic, strong) OYModel *model;

@end

NS_ASSUME_NONNULL_END
