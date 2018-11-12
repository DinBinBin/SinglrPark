//
//  JDWUserInfoDB.m
//  JDWin_B
//
//  Created by xinfu on 2018/7/16.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import "JDWUserInfoDB.h"
#include "SPPersonModel.h"

@implementation JDWUserInfoDB


+(void)saveUserInfo:(SPPersonModel *)userInfo
{
    NSTimeInterval begin, end, time;
    printf("\n==========================\n");
    begin = CACurrentMediaTime();
    NSUserDefaults *nd = ND;
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [nd setObject:udObject forKey:USER_INFO];
//    if(userInfo.userId > 0 && userInfo.access_token.length > 0){
//
//        [nd setObject:userInfo.access_token forKey:TOKEN_ID];
//        [nd setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:USER_ID];
//        [ND setObject:userInfo.password forKey:@"myPassword"];
//    }
    [nd synchronize];
    end = CACurrentMediaTime();
    time = end - begin;
    printf("Time:     %8.2f\n", time * 1000);
    //    [nd removeObjectForKey:TOKEN_ID];
    //    [nd removeObjectForKey:USER_ID];
    //    [nd removeObjectForKey:USER_INFO];
    [nd synchronize];
    
//    [self userInfo];
}

+(SPPersonModel *)userInfo
{
    NSTimeInterval begin, end, time;
    printf("\n==========================\n");
    begin = CACurrentMediaTime();
    NSData *udObject = [ND objectForKey:USER_INFO];
    SPPersonModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    
    end = CACurrentMediaTime();
    time = end - begin;
    printf("Time:     %8.2f\n", time * 1000);
    
    return userInfo;
}

+(void)deleteUserInfo
{
    NSUserDefaults *nd = ND;
//    [nd removeObjectForKey:TOKEN_ID];
//    [nd removeObjectForKey:USER_ID];
    [nd removeObjectForKey:USER_INFO];
    [nd removeObjectForKey:@"myPassword"];
    
    [nd synchronize];
}



@end
