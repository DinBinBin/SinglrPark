//
//  SPFriendDBManger.m
//  SinglePark
//
//  Created by chensw on 2019/1/18.
//  Copyright © 2019 DBB. All rights reserved.
//

#import "SPFriendDBManger.h"
#import "LKDBHelper.h"

@interface SPFriendDBManger ()

@property (nonatomic, strong) LKDBHelper *globalHelper;

@end

@implementation SPFriendDBManger
+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _globalHelper = [[LKDBHelper alloc] initWithDBName:kDB_SINGLEPARK];
    }
    return self;
}

- (SPPersonModel *)queryFriend:(int)userId {
    NSString *where = [NSString stringWithFormat:@"userId = %d", userId];
    SPPersonModel *model = [_globalHelper searchSingle:[SPPersonModel class] where:where orderBy:nil];
    return model;
}

- (void)saveFriendToDB:(SPPersonModel *)model {
    if ([self queryFriend:model.userId]) {
        return;
    }
    // 添加到数据库
    [_globalHelper insertToDB:model];

}

- (NSArray *)searchAllFeiend {
    
 
    NSArray *arr = [_globalHelper search:[SPPersonModel class] where:nil orderBy:nil offset:0 count:100];
        
    return arr;
}

@end
