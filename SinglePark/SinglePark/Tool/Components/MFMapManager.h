//
//  MFMapManage.h
//  MyFreeMall
//
//  Created by boundlessocean on 16/9/7.
//  Copyright © 2016年 GXCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@class MFMapManager;

@protocol MapManagerLocationDelegate <NSObject>

@optional
/** 更新位置 */
- (void)mapManager:(MFMapManager *)manager didUpdateAndGetLastCLLocation:(CLLocation *)location;
/** 定位失败 */
- (void)mapManager:(MFMapManager *)manager didFailed:(NSError *)error;
/** 定位功能关闭 */
- (void)mapManagerServerClosed:(MFMapManager *)manager;

@end

@interface MFMapManager : NSObject

MF_SINGLETION(MFMapManager)
/** 代理 */
@property (nonatomic, weak)     id<MapManagerLocationDelegate> delegate;
/** 授权状态 */
@property (nonatomic, readonly) CLAuthorizationStatus          authorizationStatus;
/** 开始定位 */
- (void)start;
@end
