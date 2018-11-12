//
//  JDWNetworkCache.h
//  JDWin_B
//
//  Created by Chensw on 2018/5/11.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 网络数据缓存类

@interface JDWNetworkCache : NSObject
    
    /**
     *  缓存网络数据
     *
     *  @param responseCache 服务器返回的数据
     *  @param key           缓存数据对应的key值,推荐填入请求的URL
     */
+ (void)saveResponseCache:(id)responseCache forKey:(NSString *)key;
    
    /**
     *  取出缓存的数据
     *
     *  @param key 根据存入时候填入的key值来取出对应的数据
     *
     *  @return 缓存的数据
     */
+ (id)getResponseCacheForKey:(NSString *)key;
    
    @end
