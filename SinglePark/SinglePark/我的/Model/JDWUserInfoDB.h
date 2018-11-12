//
//  JDWUserInfoDB.h
//  JDWin_B
//
//  Created by xinfu on 2018/7/16.
//  Copyright © 2018年 Chensw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPPersonModel;
@interface JDWUserInfoDB : NSObject
+(void)saveUserInfo:(SPPersonModel *)userInfo;

+(SPPersonModel *)userInfo;

+(void)deleteUserInfo;
@end
