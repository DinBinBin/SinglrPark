//
//  SPUploadingController.m
//  SinglePark
//
//  Created by 斌斌戴 on 2018/12/19.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPUploadingController.h"
#import "QiniuSDK.h"

@interface SPUploadingController ()
@property (nonatomic,copy)NSString *qiniutoken;

@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *timeLab;
@property (nonatomic,strong)UILabel *progressLab;
@property (nonatomic,strong)UIView *oldProgressView;
@property (nonatomic,strong)UIView *freshProgressView;

@end

@implementation SPUploadingController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigbackground"]];
    img.userInteractionEnabled = YES;
    img.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:img];
    
    // Do any additional setup after loading the view.
    [self setUIView];
    [self gettoken];
   
    
}


- (void)uploading:(NSString *)filePath{

    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
        [self setmodel:percent];
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:nil token:self.qiniutoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
        if (info.statusCode == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.titleLab.text = @"上传成功";
            });
            
            [self sendUPdataVideo:resp[@"key"]];
        }else{
            [MBProgressHUD showMessage:@"上传失败，请重新上传"];

        }
     }
                option:uploadOption];
    
}


- (void)gettoken{
    
    [JDWNetworkHelper POST:SPQiniuToken parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            self.qiniutoken = responseDic[@"data"][@"qiniu"];
            [self uploading:self.videopath];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
    }];
}

// 设置视图
- (void)setUIView{
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.timeLab];
    [self.view addSubview:self.progressLab];
    [self.view addSubview:self.oldProgressView];
    [self.view addSubview:self.freshProgressView];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-90);
        make.top.equalTo(self.view).offset(20+kNavigationHeight);
    }];
    

    
    [self.progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab.mas_right).offset(20);
        make.top.equalTo(self.titleLab.mas_bottom).offset(20);
    }];
    
    
    [self.oldProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLab);
        make.left.equalTo(self.titleLab);
        make.right.equalTo(self.view.mas_right).offset(-90);
        make.height.mas_equalTo(8);
    }];
    
    [self.freshProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressLab);
        make.left.equalTo(self.titleLab);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(8);
    }];
    
    
    
    
 
    
}


- (UILabel *)titleLab{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT(16);
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.text = @"正在上传";
    }
    return _titleLab;
}


- (UILabel *)timeLab{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = FONT(12);
        _timeLab.textColor = SecondWordColor;
    }
    return _timeLab;
}

- (UILabel *)progressLab{
    if (_progressLab == nil) {
        _progressLab = [[UILabel alloc] init];
        _progressLab.font = FONT(16);
        _progressLab.textColor = [UIColor whiteColor];
        _progressLab.text = @"0%";
    }
    return _progressLab;
}


- (UIView *)oldProgressView{
    if (_oldProgressView == nil) {
        _oldProgressView = [[UIView alloc] init];
        _oldProgressView.backgroundColor = [UIColor whiteColor];
    }
    return _oldProgressView;
}


- (UIView *)freshProgressView{
    if (_freshProgressView == nil) {
        _freshProgressView = [[UIView alloc] init];
        _freshProgressView.backgroundColor =  ThemeColor;
    }
    return _freshProgressView;
}

- (void)setmodel:(CGFloat )upprogress{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLab.text = [NSString stringWithFormat:@"%.2f%%",upprogress*100];
        
        [self.freshProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.oldProgressView.width*upprogress);
        }];
        
    });
}



- (void)sendUPdataVideo:(NSString *)urlpath{
    
    NSDictionary *dic =    @{@"video":urlpath};

    [JDWNetworkHelper POST:SPSendVideo parameters:dic success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            [MBProgressHUD showMessage:@"上传成功"];
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showAutoMessage:Networkerror];
    }];
    
    
}

@end

