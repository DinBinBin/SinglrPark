//
//  JDWNetworkCache.m
//  JDWin_B
//
//  Created by Chensw on 2018/5/11.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import "JDWNetworkCache.h"
#import <YYCache/YYCache.h>

@implementation JDWNetworkCache
    static NSString *const NetworkResponseCache = @"NetworkResponseCache";
    static YYCache *_dataCache;
    
    
+ (void)initialize
    {
        _dataCache = [YYCache cacheWithName:NetworkResponseCache];
    }
    
+ (void)saveResponseCache:(id)responseCache forKey:(NSString *)key
    {
        //异步缓存,不会阻塞主线程
        [_dataCache setObject:responseCache forKey:key withBlock:nil];
    }
    
+ (id)getResponseCacheForKey:(NSString *)key
    {
        return [_dataCache objectForKey:key];
    }
    
@end

