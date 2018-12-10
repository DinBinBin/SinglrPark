//
//  SPEditNickNameViewController.h
//  SinglePark
//
//  Created by chensw on 2018/12/10.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SGBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPEditNickNameViewController : SGBaseController
@property(nonatomic,copy)NSString *str;
@property (nonatomic, copy) void (^SPCallBackStringBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
