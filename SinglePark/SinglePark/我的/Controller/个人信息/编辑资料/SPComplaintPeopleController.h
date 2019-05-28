//
//  SPComplaintPeopleController.h
//  SinglePark
//
//  Created by 斌斌戴 on 2019/5/28.
//  Copyright © 2019年 DBB. All rights reserved.
//

#import "SGBaseController.h"
#import "SPPersonModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface SPComplaintPeopleController : SGBaseController
@property(nonatomic,copy)NSString *str;
@property (nonatomic,strong)SPPersonModel *model;

@end

NS_ASSUME_NONNULL_END
