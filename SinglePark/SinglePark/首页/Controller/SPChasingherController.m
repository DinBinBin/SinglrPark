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
#import "QiniuSDK.h"


#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define SOUND_RECORD_LIMIT 60

@interface SPChasingherController ()

@property (nonatomic,strong)UIImageView *backview;
@property (nonatomic,strong)UIImageView *promptImg;
@property (nonatomic,strong)UILabel *promptLab;
@property (nonatomic,strong)UIImageView *voiceimg;
@property (nonatomic,strong)UIButton *voiceBtn;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic, weak) NSTimer *timerOf60Second;
@property (nonatomic, strong) NSString *mp3DataPath;
@property (nonatomic, strong) NSString *originalDataPath;
@property (nonatomic, copy) NSString *qiuNiuStr; //七牛语音路径

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentInt; // 倒计时间

@end

@implementation SPChasingherController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigbackground"]];
    img.userInteractionEnabled = YES;
    img.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:img];

    self.title = @"追她";
    [self.view addSubview:self.backview];
    [self.backview addSubview:self.promptImg];
    [self.backview addSubview:self.promptLab];
    [self.backview addSubview:self.voiceimg];
    [self.backview addSubview:self.voiceBtn];
    [self.backview addSubview:self.timeLab];

    [self.backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(Height(-80)-KsafeTabIPhonex);
        make.left.equalTo(self.view).offset((kScreenWidth-Width(260))/2);
        make.right.equalTo(self.view.mas_right).offset(-(kScreenWidth-Width(260))/2);
        make.height.mas_equalTo(Width(300) );
    }];
    
    [self.promptImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backview).offset(3);
        make.left.equalTo(self.backview).offset(20);
        make.height.width.mas_equalTo(20);
    }];

    
    [self.promptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptImg);
        make.left.equalTo(self.promptImg.mas_right).offset(20);
        make.width.mas_equalTo(200);
        
    }];
    
    [self.voiceimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptImg.mas_bottom).offset(30);
        make.centerX.equalTo(self.backview.mas_centerX);
        make.height.width.mas_equalTo(75);
        
    }];
    
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceimg.mas_bottom).offset(30);
        make.centerX.equalTo(self.voiceimg);
        make.width.mas_equalTo(200);
        
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceBtn.mas_bottom).offset(30);
        make.left.equalTo(self.promptImg).offset(20);
        make.width.mas_equalTo(200);
        
    }];

    [self.voiceimg setCornerRadius];
    [self.voiceBtn setCornerRadius:5];
}

#pragma mark ---- 懒加载
- (UIImageView *)backview{
    if (_backview == nil) {
        _backview = [[UIImageView alloc] init];
        _backview.userInteractionEnabled = YES;
//        _backview.backgroundColor = [UIColor redColor];
        [_backview setImage:[UIImage imageNamed:@"chasingground"]];
    }
    return _backview;
}

- (UIImageView *)promptImg{
    if (_promptImg == nil) {
        _promptImg = [[UIImageView alloc] init];
        [_promptImg setImage:[UIImage imageNamed:@"小喇叭"]];

//        小喇叭
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

- (UIImageView *)voiceimg{
    if (_voiceimg == nil) {
        _voiceimg = [[UIImageView alloc] init];
        [_voiceimg sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:ImageNamed(@"logo") options:SDWebImageRefreshCached];

    }
    return _voiceimg;
}

- (UIButton *)voiceBtn{
    if (_voiceBtn == nil) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.backgroundColor = ThemeColor;
        [_voiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_voiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [_voiceBtn addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
        [_voiceBtn addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
        [_voiceBtn addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
        [_voiceBtn addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
        
    }
    return _voiceBtn;
}

- (UILabel *)timeLab{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.text = @"不超过一分钟";
        _timeLab.font = FONT(16);
        _timeLab.textColor = SecondWordColor;
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLab;
}

#pragma mark - Private Methods

/**
 *  开始录音
 */
- (void)startRecordVoice{
    self.voiceBtn.backgroundColor = SecondWordColor;
    [self.voiceBtn setTitle:@"松开 结束" forState:UIControlStateNormal];
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
        NSLog(@"-------%f",[[LGSoundRecorder shareInstance] soundRecordTime]);
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
    
//    [self sendSound];
    self.originalDataPath = [[LGSoundRecorder shareInstance] soundFilePath];

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
    self.voiceBtn.backgroundColor = ThemeColor;
    [self.voiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];

    [[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    self.voiceBtn.backgroundColor = ThemeColor;
    [self.voiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
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
        
        [self gettoken:self.mp3DataPath];

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
//    self.originalDataPath = [[LGSoundRecorder shareInstance] soundFilePath];
    self.voiceBtn.backgroundColor = [UIColor clearColor];
    [self.voiceBtn setTitle:@"已发送，请等待回音" forState:UIControlStateNormal];
    [self.voiceBtn setTitleColor:FirstWordColor forState:UIControlStateNormal];

    self.voiceBtn.enabled = NO;
    self.currentInt = 12*60*60;
    
    [self updateTimer:self.timer];
    

}
#pragma mark - set/get

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)updateTimer:(NSTimer *)timer
{
    NSInteger time = self.currentInt --;
    
    if (time <= 0) {
        if (time == 0) {
        }
        [_timer invalidate];
        _timer = nil;
        return ;
    }
    
    NSInteger h = time/ 3600;
    //分
    NSInteger m = time % 3600 / 60;
    //秒
    NSInteger s = time % 60;
    self.timeLab.text = [NSString stringWithFormat:@"%02ld小时%02ld分%02ld秒", (long)h, (long)m,(long)s];
    
}

#pragma mark - 七牛上传
- (void)gettoken:(NSString *)filePath{
    
    WEAKSELF
    STRONGSELF
    [MBProgressHUD showLoadToView:self.view];
    [JDWNetworkHelper POST:SPQiniuToken parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSString *qiniutoken = responseDic[@"data"][@"qiniu"];
            
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                NSLog(@"percent == %.2f", percent);
            }
                                                                         params:nil
                                                                       checkCrc:NO
                                                             cancellationSignal:nil];
            [upManager putFile:filePath key:nil token:qiniutoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"info ===== %@", info);
                NSLog(@"resp ===== %@", resp);
                [strongSelf uploadQiniuPath:resp[@"key"]];
                
            }
                        option:uploadOption];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
    }];
}

- (void)uploadQiniuPath:(NSString *)token {
    NSDictionary *dic = @{@"tos":[NSString stringWithFormat:@"%d",self.model.userId],@"voice":token};
    [JDWNetworkHelper POST:SPURL_API_follows_create parameters:dic success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;

        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [self sendSound];
            
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
            [self confirmRecordVoice];
        }
        
        [MBProgressHUD hideHUDForView:self.view];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [self confirmRecordVoice];

        
    }];
}


@end
