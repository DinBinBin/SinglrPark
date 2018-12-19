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
@end

@implementation SPUploadingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self gettoken];
    
}


- (void)uploading:(NSString *)filePath{

    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:nil token:self.qiniutoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
    }
                option:uploadOption];
    
}


- (void)gettoken{
    
    [JDWNetworkHelper POST:SPQiniuToken parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            self.qiniutoken = responseDic[@"data"][@"qiniu"];
            [self uploading:@""];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
    }];
}
@end

