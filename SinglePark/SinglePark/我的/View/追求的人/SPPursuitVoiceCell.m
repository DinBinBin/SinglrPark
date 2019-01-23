//
//  SPPursuitVoiceCell.m
//  SinglePark
//
//  Created by chensw on 2019/1/4.
//  Copyright © 2019 DBB. All rights reserved.
//

#import "SPPursuitVoiceCell.h"
#import "OYCountDownManager.h"
#import <AVFoundation/AVFoundation.h>


@implementation SPPursuitVoiceCell

// xib创建
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
    }
    return self;
}


#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    /// 判断是否需要倒计时 -- 可能有的cell不需要倒计时,根据真实需求来进行判断
    if (0) {
        return;
    }
    /// 计算倒计时
    OYModel *model = self.model;
    NSInteger timeInterval;
    if (model.countDownSource) {
        timeInterval = [kCountDownManager timeIntervalWithIdentifier:model.countDownSource];
    }else {
        timeInterval = kCountDownManager.timeInterval;
    }
    NSInteger countDown = model.count - timeInterval;
    /// 当倒计时到了进行回调
    if (countDown <= 0) {
        // 回调给控制器
        if (self.countDownZero) {
            self.countDownZero(model);
        }
        return;
    }
    /// 重新赋值
    self.timeLB.text = [NSString stringWithFormat:@"%02d小时%02d分%02d秒", countDown/3600, (countDown/60)%60, countDown%60];
}

///  重写setter方法
- (void)setModel:(OYModel *)model {
    _model = model;
    
//    self.timeLB.text = model.title;
    // 手动刷新数据
    [self countDownNotification];
}

- (void)setVoiceUrl:(NSString *)voiceUrl {
    if (_voiceUrl != voiceUrl) {
        _voiceUrl = voiceUrl;
        NSArray *arr = [voiceUrl componentsSeparatedByString:@"/"];
        self.voiceBtn.enabled = NO;
        [self fileName:arr.lastObject];
    }
}

- (IBAction)playVoice:(id)sender {
    
    if ([[NSFileManager defaultManager]  fileExistsAtPath:self.filePath]) {
        [[LGAudioPlayer sharePlayer] playAudioWithURLString:self.filePath atIndex:1];

    }
}


// 下载附件
- (void)fileName:(NSString *)fileName{
    NSString *str = [kDocumentDirectoryPath stringByAppendingPathComponent:@"SoundFile"];
    NSString *filestr = [str stringByAppendingPathComponent:fileName];
    NSString *file = @"";
    if (![filestr containsString:@".mp3"]) {
        file = [NSString stringWithFormat:@"%@.mp3",filestr];
    }else {
        file = filestr;
    }
    if ([[NSFileManager defaultManager]  fileExistsAtPath:file]) {
        self.voiceBtn.enabled = YES;
        self.filePath = file;
        NSLog(@"已经有 %@",file);

    }else{
        
        [JDWNetworkHelper wedownloadWithURL:self.voiceUrl fileDir:str progress:^(NSProgress *progress) {
            
        } success:^(NSString *filePath) {
            NSLog(@"下载成功----------%@",filePath);
            self.filePath = filePath;
            
            self.voiceBtn.enabled = YES;
            
        } failure:^(NSError *error) {
            [MBProgressHUD showAutoMessage:@"获取语音失败"];
        }];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - LGAudioPlayerDelegate

- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index {
    switch (audioPlayerState) {
        case LGAudioPlayerStateNormal:
            NSLog(@"正常状态");
            break;
        case LGAudioPlayerStatePlaying:
            NSLog(@"正在播放");
            break;
        case LGAudioPlayerStateCancel:
            NSLog(@"播放结束");
            break;
        default:
            break;
    }
    
}

@end
