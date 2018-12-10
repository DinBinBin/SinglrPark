//
//  SPCityModel.h
//  SinglePark
//
//  Created by chensw on 2018/12/7.
//  Copyright © 2018 DBB. All rights reserved.
//

#import "SGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPCityModel : SGBaseModel
@property (nonatomic, assign) int userID;
@property (nonatomic, copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
