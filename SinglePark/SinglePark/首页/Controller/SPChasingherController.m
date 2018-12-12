//
//  SPChasingherController.m
//  SinglePark
//
//  Created by DBB on 2018/11/30.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPChasingherController.h"
#import "VoiceButtonView.h"
#import "lame.h"
#import "LGAudioKit.h"


#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define SOUND_RECORD_LIMIT 60

@interface SPChasingherController ()

@property (nonatomic,strong)UIImageView *backview;
@property (nonatomic,strong)UIImageView *promptImg;
@property (nonatomic,strong)UILabel *promptLab;
@property (nonatomic,strong)UIButton *voiceimg;
@property (nonatomic,strong)UIButton *voiceBtn;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic, weak) NSTimer *timerOf60Second;
@property (nonatomic, strong) NSString *mp3DataPath;
@property (nonatomic, strong) NSString *originalDataPath;

@end

@implementation SPChasingherController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"追她";
    [self.view addSubview:self.backview];
    [self.backview addSubview:self.promptImg];
    [self.backview addSubview:self.promptLab];
    [self.backview addSubview:self.voiceimg];
    [self.backview addSubview:self.voiceBtn];
    [self.backview addSubview:self.timeLab];

    [self.backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.equalTo(self.view).offset(10);
        make.left.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(200);
    }];
    
    [self.promptImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backview);
        make.left.equalTo(self.backview).offset(20);
        make.height.width.mas_equalTo(20);
    }];

    
    [self.promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backview);
        make.left.equalTo(self.promptImg).offset(20);
        make.width.mas_equalTo(200);
        
    }];
    
    [self.voiceimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptImg.mas_bottom).offset(20);
        make.centerX.equalTo(self.backview);
        make.height.width.mas_equalTo(50);
        
    }];
    
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceimg.mas_bottom).offset(20);
        make.centerX.equalTo(self.voiceimg).offset(30);
        make.width.mas_equalTo(200);
        
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceBtn.mas_bottom).offset(5);
        make.left.equalTo(self.promptImg).offset(20);
        make.width.mas_equalTo(200);
        
    }];


}

#pragma mark ---- 懒加载
- (UIImageView *)backview{
    if (_backview == nil) {
        _backview = [[UIImageView alloc] init];
        _backview.userInteractionEnabled = YES;
    }
    return _backview;
}

- (UIImageView *)promptImg{
    if (_promptImg == nil) {
        _promptImg = [[UIImageView alloc] init];
        
    }
    return _promptImg;
}

- (UILabel *)promptLab{
    if (_promptLab == nil) {
        _promptLab = [[UILabel alloc] init];
        _promptLab.text = @"送一段话，让TA听见你";
        _promptLab.font = FONT(16);
        _promptLab.textColor = [UIColor whiteColor];
    }
    return _promptLab;
}

- (UIButton *)voiceimg{
    if (_voiceimg == nil) {
        _voiceimg = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _voiceimg;
}

- (UIButton *)voiceBtn{
    if (_voiceBtn == nil) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
        [_voiceBtn addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
        [_voiceBtn addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
        [_voiceBtn addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
        
    }
    return _voiceBtn;
}

#pragma mark - Private Methods

/**
 *  开始录音
 */
- (void)startRecordVoice{
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        //        //停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //        //开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:self.view recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopAndSendVedio) userInfo:nil repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    
    
    
    if ([[LGSoundRecorder shareInstance] soundRecordTime] == 0) {
        [self cancelRecordVoice];
        return;//60s自动发送后，松开手走这里
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        return;
    }
    
    [self sendSound];
    [[LGSoundRecorder shareInstance] stopSoundRecord:self.view];
    
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
    
    [self startTranscoding];
    
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecordVoice {
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
    [[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:self.view];
}


- (void)sixtyTimeStopAndSendVedio {
    int countDown = SOUND_RECORD_LIMIT - [[LGSoundRecorder shareInstance] soundRecordTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    if (countDown <= 10) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown];
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= SOUND_RECORD_LIMIT && [[LGSoundRecorder shareInstance] soundRecordTime] <= SOUND_RECORD_LIMIT + 1) {
        
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self.voiceBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    NSString *fileName = [NSString stringWithFormat:@"/voice-%5.2f.mp3", [[NSDate date] timeIntervalSince1970] ];
    self.mp3DataPath = [filePath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

- (void)startTranscoding {
    @try {
        int read, write;
        
        FILE *pcm = fopen([self.originalDataPath cStringUsingEncoding:1], "rb");//source
        fseek(pcm, 4*1024, SEEK_CUR);                                           //skip file header
        FILE *mp3 = fopen([self.mp3DataPath cStringUsingEncoding:1], "wb");     //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSString *textValue = [NSString stringWithFormat:@"转换成功：%@", self.mp3DataPath];
        NSLog(@"%@", textValue);
        //        [self excuteDelegateMethod:@"转码成功"];
    }
}


- (void)sendSound {

}
@end
