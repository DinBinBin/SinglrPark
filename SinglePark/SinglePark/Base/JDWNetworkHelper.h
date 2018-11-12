//
//  JDWNetworkHelper.h
//  JDWin_B
//
//  Created by Chensw on 2018/5/11.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JDWNetworkStatus) {
    /** 未知网络*/
    JDWNetworkStatusUnknown,
    /** 无网络*/
    JDWNetworkStatusNotReachable,
    /** 手机网络*/
    JDWNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    JDWNetworkStatusReachableViaWiFi
};


/** 请求成功的Block */
typedef void(^HttpRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^HttpRequestFailed)(NSError *error);

/** 缓存的Block */
typedef void(^HttpRequestCache)(id responseCache);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^HttJDWrogress)(NSProgress *progress);

/** 网络状态的Block*/
typedef void(^NetworkStatus)(JDWNetworkStatus status);

/** 请求任务 */
typedef NSURLSessionTask JDWURLSessionTask;

#pragma mark - 网络数据请求类


@interface JDWNetworkHelper : NSObject
    
    /**
     *  开始监听网络状态
     */
+ (void)startMonitoringNetwork;
    
    /**
     *  实时获取网络状态回调
     */
+ (void)networkStatusWithBlock:(NetworkStatus)status;
    
    /**
     *  GET请求,无缓存
     *
     *  @param URL        请求地址
     *  @param parameters 请求参数
     *  @param success    请求成功的回调
     *  @param failure    请求失败的回调
     *
     *  @return 返回的对象可取消请求,调用cancle方法
     */
+ (JDWURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
    
    /**
     *  GET请求,自动缓存
     *
     *  @param URL           请求地址
     *  @param parameters    请求参数
     *  @param responseCache 缓存数据的回调
     *  @param success       请求成功的回调
     *  @param failure       请求失败的回调
     *
     *  @return 返回的对象可取消请求,调用cancle方法
     */
+ (JDWURLSessionTask *)GET:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
    
    /**
     *  POST请求,无缓存
     *
     *  @param URL        请求地址
     *  @param parameters 请求参数
     *  @param success    请求成功的回调
     *  @param failure    请求失败的回调
     *
     *  @return 返回的对象可取消请求,调用cancle方法
     */
+ (JDWURLSessionTask *)POST:(NSString *)URL parameters:(id)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
    
    /**
     *  POST请求,自动缓存
     *
     *  @param URL           请求地址
     *  @param parameters    请求参数
     *  @param responseCache 缓存数据的回调
     *  @param success       请求成功的回调
     *  @param failure       请求失败的回调
     *
     *  @return 返回的对象可取消请求,调用cancle方法
     */
+ (JDWURLSessionTask *)POST:(NSString *)URL parameters:(NSDictionary *)parameters responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
    
    /**
     *  上传图片文件
     *
     *  @param URL        请求地址
     *  @param parameters 请求参数
     *  @param images     图片数组
     *  @param name       文件对应服务器上的字段
     *  @param fileName   文件名
     *  @param mimeType   图片文件的类型,例:png、jpeg(默认类型)....
     *  @param progress   上传进度信息
     *  @param success    请求成功的回调
     *  @param failure    请求失败的回调
     *
     *  @return 返回的对象可取消请求,调用cancle方法
     */
+ (JDWURLSessionTask *)uploadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(HttJDWrogress)progress success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
    
    /**
     *  下载文件
     *
     *  @param URL      请求地址
     *  @param fileDir  文件存储目录(默认存储目录为Download)
     *  @param progress 文件下载的进度信息
     *  @param success  下载成功的回调(回调参数filePath:文件的路径)
     *  @param failure  下载失败的回调
     *
     *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
     */
+ (JDWURLSessionTask *)downloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttJDWrogress)progress success:(void(^)(NSString *filePath))success failure:(HttpRequestFailed)failure;


#pragma mark -  Wecenter POST请求无缓存
#pragma mark - 设置AFHTTPSessionManager相关属性


+ (JDWURLSessionTask *)POST:(NSString *)URL parms:(NSDictionary *)parms success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
+ (JDWURLSessionTask *)GET:(NSString *)URL parms:(NSDictionary *)parameters success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure;
// wecenter 文件上传
+(void)POSTOneAmrWithUrl:(NSString *)url imageWithName:(NSString *)fileName dic:(NSDictionary *)dic AmrDatas:(NSData *)amr success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
// wecenter 文件下载
+ (JDWURLSessionTask *)wedownloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttJDWrogress)progress success:(void(^)(NSString *))success failure:(HttpRequestFailed)failure;

@end
