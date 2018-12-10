//
//  SPJobModel.h
//  SinglePark
//
//  Created by chensw on 2018/12/6.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SGBaseModel.h"


/**
 {
 "created_at" : "2018-08-22 17:58:44",
 "id" : 2,
 "updated_at" : "2018-08-22 18:03:03",
 "name" : "工业",
 "pid" : 0,
 "sort" : 1
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface SPJobModel : SGBaseModel
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, assign) int userId;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
