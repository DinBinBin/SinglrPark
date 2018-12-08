//
//  JDWNetworkHelper.m
//  JDWin_B
//
//  Created by Chensw on 2018/5/11.
//  Copyright © 2018年 Chensw. All rights reserved.
//


#import "JDWNetworkHelper.h"
#import "JDWNetworkCache.h"
#import <AFNetworking/AFNetworking.h>


@implementation JDWNetworkHelper
    static AFHTTPSessionManager *_manager = nil;
    static NetworkStatus _status;
    
#pragma mark - 开始监听网络
+ (void)startMonitoringNetwork
    {
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status)
            {
                case AFNetworkReachabilityStatusUnknown:
                _status(JDWNetworkStatusUnknown);
                JDWLog(@"未知网络");
                break;
                case AFNetworkReachabilityStatusNotReachable:
                _status(JDWNetworkStatusNotReachable);
                JDWLog(@"无网络");
                break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                _status(JDWNetworkStatusReachableViaWWAN);
                JDWLog(@"手机自带网络");
                break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                _status(JDWNetworkStatusReachableViaWiFi);
                JDWLog(@"WIFI");
                break;
            }
        }];
        [manager startMonitoring];
        
    }
    
+ (void)networkStatusWithBlock:(NetworkStatus)status
    {
        _status = status;
    }
    
#pragma mark - GET请求无缓存
+ (JDWURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
        return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSDictionary *dciv =  [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
      
            success(dciv);
            JDWLog(@"responseObject = %@",dciv);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            failure ? failure(error) : nil;
            JDWLog(@"error = %@",error);
        }];
    }
    
#pragma mark - GET请求自动缓存
+ (JDWURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //读取缓存
        responseCache([JDWNetworkCache getResponseCacheForKey:URL]);
        
        AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
        return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSDictionary *dciv =  [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
           
            success(dciv);
            //对数据进行异步缓存
            [JDWNetworkCache saveResponseCache:responseObject forKey:URL];
            JDWLog(@"responseObject = %@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            failure ? failure(error) : nil;
            JDWLog(@"error = %@",error);
            
        }];
    }


#pragma mark - POST请求无缓存
+ (JDWURLSessionTask *)POST:(NSString *)URL parameters:(id)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
    {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];

        return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSDictionary *dciv =  [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
          
            success(dciv);
            JDWLog(@"responseObject = %@",dciv);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            failure ? failure(error) : nil;
            JDWLog(@"error = %@",error);
            
        }];
        
    }
    
#pragma mark - POST请求自动缓存
+ (JDWURLSessionTask *)POST:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        //读取缓存
        responseCache([JDWNetworkCache getResponseCacheForKey:URL]);
        
        AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
        return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            success(responseObject);
            //对数据进行异步缓存
            [JDWNetworkCache saveResponseCache:responseObject forKey:URL];
            JDWLog(@"responseObject = %@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (error.localizedDescription) {
                [MBProgressHUD showAutoMessage:@""];
            }else{
                
            }
            failure ? failure(error) : nil;
            JDWLog(@"error = %@",error);
        }];
        
    }
    
#pragma mark - 上传图片文件
+ (JDWURLSessionTask *)uploadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(HttJDWrogress)progress success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
        return [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            //压缩-添加-上传图片
            [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@%ld.%@",fileName,idx,mimeType?mimeType:@"jpeg"] mimeType:[NSString stringWithFormat:@"image/%@",mimeType?mimeType:@"jpeg"]];
            }];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //上传进度
            progress ? progress(uploadProgress) : nil;
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSDictionary *dciv =  [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            NSString *status = [NSString stringWithFormat:@"%@",dciv[@"status"]];
            if ([status integerValue]==-1) { //  token失效
                [MBProgressHUD showAutoMessage:@"您的账号在另一台手机登录，请重新登录"];
            }
            success(dciv);
            JDWLog(@"responseObject = %@",dciv);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            failure ? failure(error) : nil;
            JDWLog(@"error = %@",error);
        }];
    }
    
#pragma mark - 下载文件
+ (JDWURLSessionTask *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttJDWrogress)progress success:(void(^)(NSString *))success failure:(HttpRequestFailed)failure
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        AFHTTPSessionManager *manager = [self createAFHTTPSessionManager];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            //下载进度
            progress ? progress(downloadProgress) : nil;
            JDWLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSString *downloadDir ;
//            if ([NSString isBlankString:fileDir]) {
//                //拼接缓存目录
//                downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
//            }else{
//                downloadDir = fileDir ;
//            }
            //打开文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //创建Download目录
            [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
            //拼接文件路径
            NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
            JDWLog(@"downloadDir = %@",downloadDir);
            //返回文件位置的URL路径
            return [NSURL fileURLWithPath:filePath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
            failure && error ? failure(error) : nil;
            
        }];
        
        //开始下载
        [downloadTask resume];
        
        return downloadTask;
        
    }
    
    
#pragma mark - 设置AFHTTPSessionManager相关属性
    
+ (AFHTTPSessionManager *)createAFHTTPSessionManager
    {
        AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
        //设置请求参数的类型:JSON (AFJSONRequestSerializer,AFHTTPRequestSerializer)
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //设置请求的超时时间
        manager.requestSerializer.timeoutInterval = 30;
#pragma mark  ----导入证书
//        [manager setSecurityPolicy:[self customSecurityPolicy]];
//        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"application/x-javascript",@"text/plain", nil]];
        //设置请求头
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

        //添加请求授权字段token
//        if ([DBAccountInfo sharedInstance].model.token) {
//            [manager.requestSerializer setValue:[DBAccountInfo sharedInstance].model.token forHTTPHeaderField:@"Authorization"];
//        }else {
//            NSLog(@"未获取到token字段");
//        }
        [manager.requestSerializer setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJTSEEyNTYifQ.eyJpc3MiOiJhcHBXaXRoWWV0aCIsImlhdCI6MTU0NDE0NDc1NCwiZXhwIjoxNTQ0NzQ5NTU0LCJpZCI6OSwidHlwZSI6InBob25lIiwidmVyc2lvbiI6Mn0.c0122c1834404a9c89fc0c0c8e7219f594c176a0e803a12ac964b49dce3ed886" forHTTPHeaderField:@"Authorization"];

        return manager;
    }

#pragma mark -  Wecenter POST请求无缓存
#pragma mark - 设置AFHTTPSessionManager相关属性
+ (AFHTTPSessionManager *)createAFHTTPSessionManagerWecenter
{
    AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
    //设置请求参数的类型:JSON (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = kSFTimeoutInterval;
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"application/x-javascript",@"text/plain", nil]];
    

    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    //设置Cookie


//    JDWUser *user = [JDWUserInfoDB  userInfo];
//    if (user.cookiedic) {
//
//        NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
//        for (NSString *key in user.cookiedic) {
//            NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [user.cookiedic valueForKey:key]];
//            [cookieValue appendString:appendString];
//        }
//        [cookieValue appendString:@"dxo__user_login=cast-256%7C556C2DD2A8F3598F02EE239F9D76154144FE0C70C9B0C95366E76900716F4FE6EC4811944C794073F370E9484E3D7BE41F7E72D01AFF7F9391D4712041F38C81D66989506D68A3103864D9AA153833C541D7B778FC200BA38B6A5A31D6781402;dxo__Session=53ls8buh8im3vuodvc8jr98jv7;"] ;
//            [manager.requestSerializer setValue:cookieValue forHTTPHeaderField:@"Cookie"];


//    }
    
    return manager;
}


// wecenter 上传附件
+(void)POSTOneAmrWithUrl:(NSString *)url imageWithName:(NSString *)fileName dic:(NSDictionary *)dic AmrDatas:(NSData *)amr success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWecenter];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {


        [formData appendPartWithFileData:amr name:@"qqfile" fileName:fileName mimeType:@"mp3"];
//    [formData appendPartWithFormData:amr name:@"qqfile"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failure(error);

    }];
    
}

#pragma mark - wecenter 下载附件
+ (JDWURLSessionTask *)wedownloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttJDWrogress)progress success:(void(^)(NSString *))success failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [self createAFHTTPSessionManagerWecenter];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com/105/media/us/imac-pro/2018/d0b63f9b_f0de_4dea_a993_62b4cb35ca96/hero/large.mp4"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        progress ? progress(downloadProgress) : nil;
        JDWLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
//        NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//        //使用建议的路径
//        path = [path stringByAppendingPathComponent:response.suggestedFilename];
        if (![[NSFileManager defaultManager] fileExistsAtPath:fileDir]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:fileDir withIntermediateDirectories:NO attributes:nil error:&error];
            if (error) {
                NSLog(@"%@", error);
            }
        }
        NSString *path = [fileDir stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"%@",path);
        return [NSURL fileURLWithPath:path];//转化为文件路径
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        failure && error ? failure(error) : nil;
    }];
    
    //开始下载
    [downloadTask resume];
    
    return downloadTask;
    
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    // 先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"sunfo-test" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //     allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //     如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
    //
    //    validatesDomainName 是否需要验证域名，默认为YES；
    //    假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //    置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //    如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
    
    return securityPolicy;
}

    @end
