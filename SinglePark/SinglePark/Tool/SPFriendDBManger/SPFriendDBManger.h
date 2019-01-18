//
//  SPFriendDBManger.h
//  SinglePark
//
//  Created by chensw on 2019/1/18.
//  Copyright © 2019 DBB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kDB_SINGLEPARK @"SinglePark.db"

@interface SPFriendDBManger : NSObject


+ (instancetype)shareInstance;

- (void)saveFriendToDB:(SPPersonModel *)model;

- (void)deleteFriend:(int)userId;

- (NSArray *)searchAllFeiend;

@end

NS_ASSUME_NONNULL_END
