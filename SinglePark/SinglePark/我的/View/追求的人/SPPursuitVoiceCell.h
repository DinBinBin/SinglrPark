//
//  SPPursuitVoiceCell.h
//  SinglePark
//
//  Created by chensw on 2019/1/4.
//  Copyright © 2019 DBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OYModel.h"
#import "LGAudioPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPPursuitVoiceCell : UITableViewCell<LGAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;

/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)(OYModel *);
@property (nonatomic, strong) OYModel *model;
@property (nonatomic, copy) NSString *voiceUrl;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) SPCallBackBlock voiceBlock;

@end

NS_ASSUME_NONNULL_END
