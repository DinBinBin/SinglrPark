//
//  DBAccountInfo.m
//  KnowledgeGold
//
//  Created by DBB on 2017/4/22.
//  Copyright © 2017年 DBB. All rights reserved.
//

#import "DBAccountInfo.h"

@implementation DBAccountInfo
static id _instance;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


@end
